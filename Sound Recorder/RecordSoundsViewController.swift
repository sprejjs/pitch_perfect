//
//  ViewController.swift
//  Sound Recorder
//
//  Created by Vlad Spreys on 26/02/15.
//  Copyright (c) 2015 Spreys.com. All rights reserved.
//


import AVFoundation
import UIKit


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var lblRecording: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!


    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.stopButton.hidden = true
        self.lblRecording.text = "Tap to Record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        self.lblRecording.text = "Recording"
        self.stopButton.hidden = false
        self.recordButton.enabled = false

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        audioRecorder = try! AVAudioRecorder(URL: filePath!, settings: [String: AnyObject]())
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: UIButton) {
        self.stopButton.hidden = true
        self.recordButton.enabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag){
            recordedAudio = RecordedAudio(url: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording wasn't successfull")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundVC = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
            
        }
    }
}
