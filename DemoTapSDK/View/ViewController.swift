//
//  ViewController.swift
//  DemoTapSDK
//
//  Created by Kokila Ekanayake on 8/2/23.
//

import UIKit
import Alamofire
import goSellSDK

class MainVC: UIViewController {
    
    @IBOutlet weak var payButton: PayButton!
    
    let vm = ViewModel();
    var knownCustomer = false

    override func viewDidLoad() {
        super.viewDidLoad()
        payButton.delegate = self
        payButton.dataSource = self
    }

    func navigateToWebView(_ urlString: String) {
        let vc = WebContentVC.storyboardInstantiate(in: .Main, identifier: "WebContentVC")
        vc.website = .ANY(url: urlString)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func payAction(_ sender: Any) {
        vm.tapChargeNetworkRequest(decodable: TapChargeModel.self) { [weak self] response, error, code in
            guard let _ = self else { return }
            if code == 200, let url = response?.transaction?.url {
                self?.navigateToWebView(url)
            } else {
                print(String(data: error as! Data, encoding: String.Encoding.utf8) ?? "")
            }
        }
    }
}

extension MainVC: goSellSDK.SessionDelegate, goSellSDK.SessionDataSource {
    
    var customer: goSellSDK.Customer? {
        if knownCustomer {
            return self.identifiedCustomer
        } else {
            return self.newCustomer
        }
    }

    /// Creating a customer with known identifier received from Tap before.
    var identifiedCustomer: goSellSDK.Customer? {
        return try? goSellSDK.Customer(identifier: "")
    }

    /// Creating a customer with raw information.
    var newCustomer: goSellSDK.Customer? {
        let emailAddress = try! EmailAddress(emailAddressString: "customer@mail.com")
        let phoneNumber = try! PhoneNumber(isdNumber: "965", phoneNumber: "96512345")
            
        return try? goSellSDK.Customer(emailAddress: emailAddress, phoneNumber: phoneNumber, name: "Test User")
    }
    
    var currency: Currency? {
        return .with(isoCode: "KWD")
    }
    
    var amount: Decimal {
        return 1.0
    }
    
    var postURL: URL? {
        return URL(string: "https://tap.company/post")
    }
    
    private var receiptSettings: Receipt? {
        return Receipt(email: true, sms: true)
    }
    
    var allowsToSaveSameCardMoreThanOnce: Bool {
        return false
    }
    
    var applePayMerchantID: String {
        return "merchant.com.example"
    }
    
    func paymentSucceed(_ charge: Charge, on session: SessionProtocol) {
        print("Payment Success")
    }
    
    func paymentFailed(with charge: Charge?, error: TapSDKError?, on session: SessionProtocol) {
        print("Payment Failed")
    }
}

// MARK: - ViewModel
class ViewModel {
    
    func tapChargeNetworkRequest<T: Decodable>(decodable: T.Type, completion: @escaping (_ response: T?, _ error: Any?, _ code: Int) -> ()) {
        let headers: HTTPHeaders = [
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer \(Constants.shared.TAP_SECRET_KEY)"
        ]
        
        let parameters: [String : Any] = [
          "amount": 1,
          "currency": "KWD",
          "customer_initiated": true,
          "threeDSecure": false,
          "save_card": false,
          "description": "Test Description",
          "metadata": ["udf1": "Metadata 1"],
          "reference": [
            "transaction": "txn_01",
            "order": "ord_01"
          ],
          "receipt": [
            "email": true,
            "sms": true
          ],
          "customer": [
            "first_name": "Chamal",
            "middle_name": "Priyankara",
            "last_name": "Gunarathne",
            "email": "chamal@codezync.com",
            "phone": [
              "country_code": 94,
              "number": 710553189
            ]
          ],
          "source": ["id": "src_all"],
          "post": ["url": "http://your_website.com/post_url"],
          "redirect": ["url": "https://www.tmdone.com"]
        ]
        
        AF.request("https://api.tap.company/v2/charges", method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers).validate()
            .cURLDescription { description in print(description) }
            .responseDecodable(of: decodable.self) { response in
                completion(response.value, response.data ?? response.error, response.response?.statusCode ?? 500)
            }
    }
}
