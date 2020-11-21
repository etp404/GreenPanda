//
//  GreenPandaTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 21/10/2020.
//

import XCTest
import Combine

@testable import GreenPanda

class MockupOfCombineVersion: XCTestCase {

    var anyCancellable: AnyCancellable?

    func testToRunCombineScript() {
        let model = Model()
        
        let viewModel = ViewModel(model: model)
        model.someValueOfModelBackingValue = [20, 50]
        
       
        
        anyCancellable = viewModel.$someValueOnViewModel
                .sink(receiveValue: { newCharge in
                   print("The car now has \(newCharge)kwh in its battery")
                })
        
        model.someValueOfModelBackingValue.append(40)
        
    }
    
}

class Model: ModelProtocol {
    var someValueOnModel: Published<[Double]>.Publisher {
        $someValueOfModelBackingValue
    }
    
    @Published var someValueOfModelBackingValue = [50.0, 10.0]
}

protocol ModelProtocol {
     var someValueOnModel:Published<[Double]>.Publisher  { get }
}

class ViewModel {
    var anyCancellable2: AnyCancellable?

    init(model:Model) {
        anyCancellable2 = model.someValueOnModel.map{value in
            value.map{"Value is \($0)"}
        }.sink(receiveValue: {
            self.someValueOnViewModel = $0
        })
    }
    @Published var someValueOnViewModel = ["value1", "value2"]
}
