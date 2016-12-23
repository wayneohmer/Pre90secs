//
//  ViewController.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/15/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation


class P9STimerController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pausedLabel: UILabel!
    @IBOutlet weak var pausedTimeLabel: UILabel!
    @IBOutlet weak var inspirationImageView: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var settingsButton: P9SRoundButton!
    @IBOutlet weak var logButton: P9SRoundButton!
    @IBOutlet weak var addDetailButton: P9SRoundButton!
    @IBOutlet weak var randomButton: P9SRoundButton!
    @IBOutlet weak var randomLabel: UILabel!
    
    var timer:Timer? = nil
    var countDown = P9SGlobals.maxtime
    var pausedTime = Int(0)
    var pausedAtTime = Int(0)
    var paused = false
    var maxTime = P9SGlobals.maxtime
    var images = [UIImage]()
    let speechSynthesizer = AVSpeechSynthesizer()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.countDown = self.maxTime
        self.timeLabel.text = "\(self.countDown)"
        self.images = [UIImage(named:"Josh1")!,UIImage(named:"Josh2")!,UIImage(named:"Josh3")!]
        self.fixInstructions()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.maxTime = P9SGlobals.maxtime
        self.timeLabel.text = "\(self.maxTime)"
        self.progressSlider.maximumValue = Float(self.maxTime)

    }

    @IBAction func timeTouched(_ sender: UITapGestureRecognizer) {
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.resetButton.isHidden = false
        self.settingsButton.isHidden = true
        self.logButton.isHidden = true
        self.randomButton.isHidden = true
        self.randomLabel.isHidden = true
        self.timeLabel.alpha = 0.5
        UIView.animate(withDuration: 0.5, animations:{
            self.timeLabel.alpha = 1.0
        })
        if self.timer == nil {
            self.countDown = self.maxTime;
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                self.timerChanged()
            })
             self.fixInstructions()
            
        } else {
            self.paused = !self.paused
            self.pausedLabel.isHidden = !self.paused
            self.pausedAtTime = self.countDown
            self.pausedLabel.text = "Paused at \(self.countDown)"
            self.pausedTimeLabel.isHidden = !self.paused
            self.progressSlider.isUserInteractionEnabled = !self.progressSlider.isUserInteractionEnabled
            self.progressSlider.thumbTintColor = self.progressSlider.isUserInteractionEnabled ? UIColor.blue : UIColor.lightGray
            self.fixInstructions()
        }
    }
    
   func timerChanged() {
        if self.countDown == 0 && !self.paused {
            UIApplication.shared.isIdleTimerDisabled = false

            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            speechSynthesizer.speak(AVSpeechUtterance(string:P9SGlobals.finishedWords))

            self.timer?.invalidate()
            self.timer = nil;
            self.inspirationImageView.image = self.images[Int(arc4random_uniform(3))]
            
            UIView.animate(withDuration: 0.5, animations:{
                self.inspirationImageView.alpha = 1.0
            }, completion: { finished in
                self.fixInstructions()

            })
            self.paused = false
            self.progressSlider.isHidden = true;
            self.addDetailButton.isHidden = false;
            P9SGlobals.log.append(P9SlogEntry(date:Date(), exersises:"", note:""))
            return
        }
        if self.paused {
            self.pausedTime += 1;
            self.pausedTimeLabel.text = "\(self.pausedTime)"

        } else {
            self.countDown -= 1;
            if P9SGlobals.spokenTimes.contains(self.countDown) {
                speechSynthesizer.speak(AVSpeechUtterance(string:"\(self.countDown)"))
            }
            self.timeLabel.text = "\(self.countDown)"
            UIView.animate(withDuration: 1, animations:{
                self.progressSlider.setValue(Float(self.maxTime - self.countDown), animated:true)
            })
        }
    
    }
     
    @IBAction func randomButtonTouched(_ sender: P9SRoundButton) {
        //rigmarole to stop repeats.
        var newText = P9SGlobals.exersises[Int(arc4random_uniform(UInt32(P9SGlobals.exersises.count)))]
        var maxCounter = 0
        while newText == self.randomLabel.text && maxCounter < 10 {
            newText = P9SGlobals.exersises[Int(arc4random_uniform(UInt32(P9SGlobals.exersises.count)))]
            maxCounter += 1
        }
        self.randomLabel.text = newText
        self.randomLabel.isHidden = false
    }
    
    @IBAction func progressSliderValueChanged(_ sender: UISlider) {
        self.countDown = self.maxTime - Int(sender.value)
        self.timeLabel.text = "\(self.countDown)"
        self.progressSlider.thumbTintColor =  self.countDown < self.pausedAtTime ? UIColor.red : UIColor.blue
            
    }
    
    func fixInstructions() {
        self.instructionsLabel.text = (self.paused || self.timer == nil) ? "Touch time to start" : "Touch time to pause"
    }
    
    func reset() {
        UIApplication.shared.isIdleTimerDisabled = false
        self.timer?.invalidate()
        self.timer = nil;
        self.countDown = self.maxTime
        self.pausedTime = 0
        self.timeLabel.text = "\(self.countDown)"
        self.paused = false;
        self.pausedLabel.isHidden = !self.paused
        self.pausedTimeLabel.isHidden = !self.paused
        self.fixInstructions()
        self.inspirationImageView.alpha = 0
        self.resetButton.isHidden = true
        self.progressSlider.value = self.progressSlider.minimumValue
        self.progressSlider.isHidden = false
        self.settingsButton.isHidden = false
        self.logButton.isHidden = false
        self.randomButton.isHidden = false
        self.addDetailButton.isHidden = true
        self.progressSlider.isUserInteractionEnabled = false
        self.progressSlider.thumbTintColor = UIColor.lightGray

    }
    
    @IBAction func inspirationImageTouched(_ sender: UITapGestureRecognizer) {
        self.reset()
    }
    
    @IBAction func resetTouchced(_ sender: UIButton) {
        self.reset()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        if segue.identifier == "DetailEntryExit" {
            self.reset()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

