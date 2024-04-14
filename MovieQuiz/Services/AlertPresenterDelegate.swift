//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Pavel Barto on 14.04.2024.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(with model: AlertModel)
}
