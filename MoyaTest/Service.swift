//
//  Service.swift
//  MoyaTest
//
//  Created by Kairzhan Kural on 10/19/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import Foundation
import Moya

enum Service {
    case createUser(name: String)
    case getUsers
    case updateUser(id: Int, name: String)
    case deleteUser(id: Int)
}

extension Service: TargetType {
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .getUsers, .createUser(_):
            return "/users"
        case .deleteUser(let id), .updateUser(let id, _):
            return "/users/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createUser(_):
            return .post
        case .deleteUser(_):
            return .delete
        case .updateUser(_, _):
            return .put
        case .getUsers:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .createUser(let name):
            return "{'name': '\(name)'}".data(using: .utf8)!
        case .deleteUser(let id):
            return "{'id': '\(id)'}".data(using: .utf8)!
        case .updateUser(let id, let name):
            return "{'id': '\(id)', 'name': '\(name)'}".data(using: .utf8)!
        case .getUsers:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .deleteUser(_), .getUsers:
            return .requestPlain
        case .updateUser(_, let name), .createUser(let name):
            return .requestParameters(parameters: ["name": name], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
}

