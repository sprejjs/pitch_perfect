//
//  RecordedAudio.swift
//  Sound Recorder
//
//  Created by Vlad Spreys on 27/02/15.
//  Copyright (c) 2015 Spreys.com. All rights reserved.
//

import Foundation

class RecordedAudio : NSObject {
    private(set) var filePathUrl: NSURL!
    private(set) var title: String!
    
    init(url: NSURL!, title: String) {
        self.filePathUrl = url
        self.title = title
    }
}
