//
//  ViewController.swift
//  fingerAuthentication
//
//  Created by Jose Martin Salcedo Lazaro on 3/16/18.
//  Copyright © 2018 Jose Martin Salcedo Lazaro. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
  
  

  override func viewDidLoad() {
    super.viewDidLoad()
    authenticationWithTouchID()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

extension ViewController{
  
  func authenticationWithTouchID() {
    
    let localAuthenticationContext = LAContext()
    localAuthenticationContext.localizedFallbackTitle = "Use PassCode"
    
    var authError: NSError?
    let reasonData = "To access the secure data"
    
    if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError){
      localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonData, reply: { (success, evaluateError) in
        if success {
          print("se auntentico con exito")
        } else {
          guard let error = evaluateError else{
            return
          }
          print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
        }
      })
    }
  }
  
  func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
    
    var message = ""
    
    if #available(iOS 11.0, *){
      switch errorCode {
      case LAError.biometryNotAvailable.rawValue:
        message = "La auntenticacion no se empezo por que el dispositivo no soporta la autenticacion del biometrico"
      case LAError.biometryLockout.rawValue:
        message = "No se pudo autenticar por que se se ha blooqueado el biometrico por que se intento ingresar varias veces."
      case LAError.biometryNotEnrolled.rawValue:
        message = "La auntenticacion no se inicio exitosamente, por que no se encuentra registrado en el biometrico"
      default:
        message = "No se definio el error con el codifo de LA Error"
      }
    } else {
      switch errorCode{
      case LAError.touchIDLockout.rawValue:
        message = "Realizo muchos intentos fallidos"
      case LAError.touchIDNotEnrolled.rawValue:
        message = "No esta registrado en el biometico de su dispositivo"
      case LAError.touchIDNotAvailable.rawValue:
        message = "El touchid no soporta su device"
      default:
        message = "Se encontro un error en objeto LAError"
      }
    }
    
    return message
    
  }
  
  func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
    
    var message = ""
    
    switch errorCode {
    case LAError.authenticationFailed.rawValue:
      message = "El usuario fallo en sus credenciales"
    case LAError.appCancel.rawValue:
      message = "La auntenticacion ha sido cancelada por la aplicacion"
    case LAError.invalidContext.rawValue:
      message = "El contexto es invalido"
    case LAError.notInteractive.rawValue:
      message = "El codigo de seguridad no es el mismo del dispositivo"
    case LAError.systemCancel.rawValue:
      message = "La autenticacion ha sido cancelada por el sistema"
    case LAError.userCancel.rawValue:
      message = "El usuario cancelo"
    case LAError.userFallback.rawValue:
      message = "el Usuario eligio el Fallback"
    default:
      message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
    }
    
    return message
    
  }
  
}
