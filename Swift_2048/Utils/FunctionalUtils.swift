//
//  FunctionalUtils.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 7/23/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//


func bind<T, U>(_ x: T, _ closure: (T) -> U) -> U {
    return closure(x)
}
