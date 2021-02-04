//
//  NewRecordingViewController.swift
//  GuitarBox
//
//  Created by Benoit Lord on 2018-11-25.
//  Copyright © 2018 Benoit Lord. All rights reserved.
//

import UIKit
import AVFoundation

class NewRecordingViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK: Propriétés
    @IBOutlet weak var recordStopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var recording:Bool = false
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioFilename = URL(string: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recording = false
        stop()
        
        //Localization
        navigationItem.title = NSLocalizedString("new", comment: "")
        
        //pour enregistrer
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //succeded
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    //MARK: Actions
    @IBAction func recordStop(_ sender: Any) {
        
        //is not recording, start
        if !recording {
            //partir l'enregistrement
            audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                recording = true
                
                //changer l'image du bouton
                recordStopButton.setImage(UIImage(named: "boutonStop"), for: .normal)
            } catch {
                //finishRecording(success: false)
            }
        }
        //is recording, stop
        else{
            //arrêter l'enregistrement
            audioRecorder.stop()
            audioRecorder = nil
            
            /*if success {
                recordButton.setTitle("Tap to Re-record", for: .normal)
            } else {
                recordButton.setTitle("Tap to Record", for: .normal)
                // recording failed :(
            }*/
            
            recording = false
            
            //changer l'image du bouton
            recordStopButton.setImage(UIImage(named: "boutonRecord"), for: .normal)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let settingsViewController = storyBoard.instantiateViewController(withIdentifier: "settingsView") as! SettingsViewController
            settingsViewController.filePath = audioFilename
            self.present(settingsViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func pause(_ sender: Any) {
        
    }
    
    //MARK: Fonctions
    func record(){
        
    }
    
    func stop(){
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }*/
 

}
