//
//  ViewController.swift
//  DemoTapSDK
//
//  Created by Kokila Ekanayake on 8/2/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let vm = ViewModel();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
