//
//  ViewController.swift
//  WeatherApp
//
//  Created by Cheng Guo on 2023/3/8.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
class ViewController: UIViewController {
    private let cities = [CityModel(cityName: "London", latitude: 51.5073359, longitude: -0.12765),
                          CityModel(cityName: "Helsinki", latitude: 60.1674881, longitude: 60.1674881)]
    private let disposeBag = DisposeBag()
    private let weatherViewModel = WeatherViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - BindViewModel
    func bindViewModel () {
        segmentControl.rx.selectedSegmentIndex.map { [unowned self] selectedSegmentIndex in
            return cities.map { $0.cityName }[selectedSegmentIndex]
        }.bind(to: cityNameLabel.rx.text).disposed(by: disposeBag)
        
        // Combine segmentControlEvents with timer sequeces, when a new element is emitted from either of them, start to reload weather data
        let getWeatherCountDownSequence = Observable<Int>.interval(DispatchTimeInterval.seconds(60), scheduler: MainScheduler.instance).startWith(0)
        let citySequence = segmentControl.rx.selectedSegmentIndex.map({ [unowned self] selectedSegmentIndex in
            return cities[selectedSegmentIndex]
        })
        let refreshSequence = Observable.combineLatest(getWeatherCountDownSequence, citySequence) { _, city in
            return city
        }
        let input = WeatherViewModel.Input(city: refreshSequence)
        let output = weatherViewModel.transform(input: input)
        
        // handle the output, update temperature value and date
        output.weather.subscribe { [unowned self] event in
            switch event {
            case .next(let weatherResponseModel):
                temperatureLabel.text = String(format: "Temperature: %.2f℃", weatherResponseModel.weather.temp)
                lastUpdateTimeLabel.text = "Updated: \(Date().dateString())"
            case .error(let error):
                print("Error:", error.localizedDescription)
            default:
                break
            }
        }.disposed(by: disposeBag)
        //output.weather.map { String(format: "%.2f℃", $0.weather.temp)}.bind(to: temperatureLabel.rx.text).disposed(by: disposeBag)
    }
    
    // MARK: - SetupUI
    func setupUI() {
        title = "Weather"
        view.addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(120)
        }
        
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.centerX.equalTo(cityNameLabel)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(50)
        }
        
        view.addSubview(lastUpdateTimeLabel)
        lastUpdateTimeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(cityNameLabel)
            make.top.equalTo(temperatureLabel.snp.bottom).offset(15)
        }
        
        view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.centerX.equalTo(cityNameLabel)
            make.top.equalTo(lastUpdateTimeLabel.snp.bottom).offset(50)
        }
    }
    
    // MARK: - Lazy Getters
    lazy var cityNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "--"
        return label
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Temperature: --"
        return label
    }()
    
    lazy var lastUpdateTimeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Updated: --"
        return label
    }()

    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: cities.map { $0.cityName })
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
}

