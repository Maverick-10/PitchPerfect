//
//  ViewController.swift
//  PitchPerfect
//
//  Created by bhuvan on 03/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: Properties
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stopRecordingButton.isEnabled = false
    }

    // MARK: Actions
    @IBAction func recordAudio(_ sender: Any) {
        
        configureUI(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        
        audioRecorder = try! AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false, options: [])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: UI updates
    func configureUI(_ isRecording: Bool) {
        
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
        
        if isRecording {
            recordingLabel.text = "Recording in Progress"
        } else {
            recordingLabel.text = "Tap to record"
        }
    }
}

// MARK: AVAudioRecorderDelegate 
extension RecordSoundsViewController : AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            let alertController = UIAlertController(title: "Recording Error", message: "Something went wrong, please try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}
