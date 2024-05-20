//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Pavel Barto on 14.04.2024.
//

import UIKit


final class AlertPresenter: AlertPresenterProtocol {

    func presentAlert(vc: UIViewController, alert: AlertModel) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertController.view.accessibilityIdentifier = "Game Results"
        let action = UIAlertAction(title: alert.buttonText, style: .default) { _ in
            alert.completion()
        }
        alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
    }
}

