//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Pavel Barto on 18.04.2024.
//

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func presentAlert(vc: UIViewController, alert: AlertModel)
}
