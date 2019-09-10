//
//  Request.swift
//  TestProject
//
//  Created by alina.golubeva on 10/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import RxSwift
import Alamofire
import RxAlamofire
import CodableAlamofire

class Request {
    
    private func makeRxRequest<T: Decodable>(method: HTTPMethod, path: Path, parameters: [String: Any]?) -> Single<T> {
        let request: Single<T> = makeRxAlamofireRequest(method: method, path: path, parameters: parameters).concatMap { [unowned self] dataRequest in
            self.responseDecodableObject(dataRequest: dataRequest)
        }.asSingle()
        return request
    }
    
    private func responseDecodableObject<T: Decodable>(dataRequest: DataRequest) -> Single<T> {
        let observable: Single<T> = Single.create { single -> Disposable in
            dataRequest.responseDecodableObject(queue: nil, keyPath: nil, decoder: JSONDecoder()) { (response: DataResponse<T>) in
                guard let value = response.result.value else {
                    single(.error(NSError(domain: "Error", code: 0, userInfo: nil)))
                    return
                }
                single(.success(value))
            }
            return Disposables.create()
        }
        return observable
    }
    
    private func makeRxAlamofireRequest(method: HTTPMethod, path: Path, parameters: [String: Any]?) -> Observable<DataRequest> {
        let request = RxAlamofire.request(method, path.url, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        return request
    }
}

extension Request: RequestProtocol {
    func makeRxGetRequest<T>(path: Path, parameters: [String : Any]?) -> Single<T> where T : Decodable, T : Encodable {
        return makeRxRequest(method: .get, path: path, parameters: parameters)
    }
}
