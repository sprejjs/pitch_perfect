//
//  PlaySoundsViewController.swift
//  Sound Recorder
//
//  Created by Vlad Spreys on 26/02/15.
//  Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer : AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    
    override func viewDidLoad() {
        self.audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        self.audioPlayer.enableRate = true
        self.audioEngine = AVAudioEngine()
    }

    @IBAction func playSlow(sender: UIButton) {
        self.playAudio(0.5)
    }
    
    @IBAction func playFast(sender: UIButton) {
        self.playAudio(1.5)
    }
    
    func playAudio(rate: Float){
        stopPlaying()
        self.audioPlayer.rate = rate
        self.audioPlayer.currentTime = 0
        self.audioPlayer.play()
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        stopPlaying();
    }

    func stopPlaying(){
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
    }

    func playAudioWithPitch(pitch: Float) {
        stopPlaying()

        var pitchPlayer = AVAudioPlayerNode()
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(timePitch)
        
        let myAudioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioEngine.connect(pitchPlayer, to: timePitch, format: myAudioFile.processingFormat)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: myAudioFile.processingFormat)
        
        pitchPlayer.scheduleFile(myAudioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        pitchPlayer.play()
    }
    @IBAction func playDartWaider(sender: UIButton) {
        playAudioWithPitch(-1000)
    }
    
    @IBAction func playChipmankAudio(sender: UIButton) {
        playAudioWithPitch(1000)
    }
}