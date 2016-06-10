//
//  AudioUtil.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 6/9/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer!

func playAudio(audioFile: String) {
    let path = NSBundle.mainBundle().pathForResource(audioFile, ofType: "wav")
    do {
        audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path!)!)
        audioPlayer.prepareToPlay()
        audioPlayer.numberOfLoops = 0
        audioPlayer.play()
    } catch let err as NSError {
        print(err.debugDescription)
    }
}