//
//  Result.swift
//  Domain
//
//  Created by thanos kottaridis on 1/2/23.
//

import Foundation

enum Result<T, E> {
    case Success(T)
    case Failure(E)
}
