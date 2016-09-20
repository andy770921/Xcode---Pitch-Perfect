//
//  ViewController.swift
//  TunePerfect
//
//  Created by Andy Chou on 2016/9/1.
//  Copyright © 2016年 Andy Chou. All rights reserved.
//

import UIKit
import AVFoundation

class RecViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var RecBtn: UIButton!
    @IBOutlet weak var StopRecBtn: UIButton!
    @IBOutlet weak var RecordingLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the , typically from a nib.
    }
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func RecordAudio(sender: AnyObject) {
        print("Record button pressed")
        StopRecBtn.enabled = true
        RecBtn.enabled = false
        RecordingLabel.text = "Recording in progress"
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
        let recordingName = "recordingVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
   

    @IBAction func StopRecording(sender: AnyObject) {
        RecBtn.enabled = true
        StopRecBtn.enabled = false
        RecordingLabel.text = "Tap to Record"
        print("Stop recording")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    
    }

    override func viewWillAppear(animated: Bool) {
        StopRecBtn.enabled = false
      }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if(flag){
        self.performSegueWithIdentifier("SecondPageLinkage", sender: audioRecorder.url)
        }
        else {print("Saving of recording failed")}
    }
 
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "SecondPageLinkage"){
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURLfromRecVC = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURLfromRecVC
            print("The .wav file URL has hen passed to PlaySoundsVC successfully")
        }
    }
}

