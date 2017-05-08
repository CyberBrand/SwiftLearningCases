import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var screen: UILabel!
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    var mind =  Mind()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        mind.delegate = self
    }

    @IBAction func digit(_ sender: UIButton) {
        mind.insertOperand(operand: Double(sender.currentTitle!)!)
    }


    @IBAction func operation(_ sender: UIButton) {
        mind.operation(operation: sender.currentTitle)
    }
    
    @IBAction func removeCalcul(_ sender: UIButton) {
        screen.text = String(0)
        mind = Mind()
        mind.delegate = self
    }
    
}

extension ViewController : canShowMyMind {
    func resultDidChanged(_ result: String){
        screen.text = result
    }
    func getCurrentTitleScreen()-> String{
        return screen.text ?? ""
    }
}

