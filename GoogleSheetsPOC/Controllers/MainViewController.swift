import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

class MainViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    private let service = GTLRSheetsService()
    
    @IBAction func createAccountButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = [
            "https://www.googleapis.com/auth/spreadsheets"
        ]
        
        GIDSignIn.sharedInstance().clientID = "832262025030-be31sijfsd1btmfh6f3hm0u0bd8u1nou.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
    }
    
    // MARK: Private functions
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            let cancel = NSLocalizedString("Cancel", comment: "")
            let AuthenticationError = NSLocalizedString("AuthenticationError", comment: "")
            
            let alertController = UIAlertController(title: AuthenticationError,
                                                    message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
            alertController.show()
            self.service.authorizer = nil
        } else {
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            navigate()
        }
    }
    
    func navigate() {
        let setSheetViewController = SetSheetViewController()
        setSheetViewController.service = service
        self.present(setSheetViewController, animated: true, completion: nil)
    }
}
