//
//  Post.swift
//  Killer
//
//  Created by Joe Hicks on 10/06/2015.
//  Copyright (c) 2015 Joe Hicks. All rights reserved.
//

import Foundation
import UIKit
var oldData = ""

func makePregameJSON(targ:Int, player:String) -> String {
    var JSON:String = "{\"players\":["
    for i in 0..<playerNames.count {
        JSON += "{\"name\":\""
        JSON += playerNames[i]
        JSON += "\", \"num\":"
        var num = "\"\""
        if i < playerNumbers.count {
            num = String(playerNumbers[i])
        }
        JSON += num
        JSON += ", \"lives\":"
        JSON += String(3)
        JSON += ", \"killer\":"
        var isKiller = "false"
        JSON += isKiller
        JSON += "}"
        if i != (playerNames.count - 1) {
            JSON += ", "
        }
    }
    JSON += "], \"currentPlayer\":\""
    var playerToShow = "Killer"
    if player != "" {
        playerToShow = player
    }
    if playerNumbers.count == playerNames.count {
        if playerNames.count != 0 {
            playerToShow = playerNames.first!
        }
    } else if playerNumbers.count > 0 {
        playerToShow = playerNames[playerNumbers.count]
    }
    JSON += playerToShow
    //JSON += players[go].name
    JSON += "\", \"currentTargetName\":\""
    //JSON += currentTargetLabel.text!
    JSON += ""
    JSON += "\", \"currentTargetNumber\":"
    var targetNumber = "\"\""
    if targ != 0 {
        targetNumber = String(targ)
    }
    JSON += targetNumber
    //JSON += String(players[players[go].tgt[players[go].throw - 1]].num)
    JSON += ", \"targets\":[{\"num\":"
    JSON += "\"\""
    JSON += "}, {\"num\":"
    JSON += "\"\""
    JSON += "}, {\"num\":"
    JSON += "\"\""
    JSON += "}], \"colours\":[{\"num\":"
    JSON += String(0)
    JSON += "}, {\"num\":"
    JSON += String(0)
    JSON += "}, {\"num\":"
    JSON += String(0)
    JSON += "}], \"throw\":"
    JSON += String(1)
    JSON += "}"
    return JSON
}

func makePregameJSON(targ:Int, player:String, targets:[Int]) -> String {
    var JSON:String = "{\"players\":["
    for i in 0..<playerNames.count {
        JSON += "{\"name\":\""
        JSON += playerNames[i]
        JSON += "\", \"num\":"
        var num = "\"\""
        if i < playerNumbers.count {
            num = String(playerNumbers[i])
        }
        JSON += num
        JSON += ", \"lives\":"
        JSON += String(3)
        JSON += ", \"killer\":"
        var isKiller = "false"
        JSON += isKiller
        JSON += "}"
        if i != (playerNames.count - 1) {
            JSON += ", "
        }
    }
    JSON += "], \"currentPlayer\":\""
    var playerToShow = "Killer"
    if player != "" {
        playerToShow = player
    }
    if playerNumbers.count == playerNames.count {
        if playerNames.count != 0 {
            playerToShow = playerNames.first!
        }
    } else if playerNumbers.count > 0 {
        playerToShow = playerNames[playerNumbers.count]
    }
    JSON += playerToShow
    //JSON += players[go].name
    JSON += "\", \"currentTargetName\":\""
    //JSON += currentTargetLabel.text!
    JSON += "Yourself"
    JSON += "\", \"currentTargetNumber\":"
    var targetNumber = "\"\""
    if targ != 0 {
        targetNumber = String(targ)
    }
    JSON += targetNumber
    //JSON += String(players[players[go].tgt[players[go].throw - 1]].num)
    JSON += ", \"targets\":[{\"num\":"
    JSON += String(targets[0])
    JSON += "}, {\"num\":"
    JSON += String(targets[1])
    JSON += "}, {\"num\":"
    JSON += String(targets[2])
    JSON += "}], \"colours\":[{\"num\":"
    JSON += String(1)
    JSON += "}, {\"num\":"
    JSON += String(1)
    JSON += "}, {\"num\":"
    JSON += String(1)
    JSON += "}], \"throw\":"
    JSON += String(1)
    JSON += "}"
    return JSON
}


func makePregameJSON(targ:Int) -> String {
    var JSON:String = "{\"players\":["
    for i in 0..<playerNames.count {
        JSON += "{\"name\":\""
        JSON += playerNames[i]
        JSON += "\", \"num\":"
        var num = "\"\""
        if i < playerNumbers.count {
            num = String(playerNumbers[i])
        }
        JSON += num
        JSON += ", \"lives\":"
        JSON += String(3)
        JSON += ", \"killer\":"
        var isKiller = "false"
        JSON += isKiller
        JSON += "}"
        if i != (playerNames.count - 1) {
            JSON += ", "
        }
    }
    JSON += "], \"currentPlayer\":\""
    var playerToShow = "Killer"
    if playerNumbers.count == playerNames.count {
        if playerNames.count != 0 {
            playerToShow = playerNames.first!
        }
    } else if playerNumbers.count > 0 {
        playerToShow = playerNames[playerNumbers.count]
    }
    JSON += playerToShow
    //JSON += players[go].name
    JSON += "\", \"currentTargetName\":\""
    //JSON += currentTargetLabel.text!
    JSON += ""
    JSON += "\", \"currentTargetNumber\":"
    var targetNumber = "\"\""
    if targ != 0 {
        targetNumber = String(targ)
    }
    JSON += targetNumber
    //JSON += String(players[players[go].tgt[players[go].throw - 1]].num)
    JSON += ", \"targets\":[{\"num\":"
    JSON += "\"\""
    JSON += "}, {\"num\":"
    JSON += "\"\""
    JSON += "}, {\"num\":"
    JSON += "\"\""
    JSON += "}], \"colours\":[{\"num\":"
    JSON += String(0)
    JSON += "}, {\"num\":"
    JSON += String(0)
    JSON += "}, {\"num\":"
    JSON += String(0)
    JSON += "}], \"throw\":"
    JSON += String(1)
    JSON += "}"
    return JSON
}

func makePregameJSON() -> String {
    var JSON:String = "{\"players\":["
    for i in 0..<playerNames.count {
        JSON += "{\"name\":\""
        JSON += playerNames[i]
        JSON += "\", \"num\":"
        var num = "\"\""
        if i < playerNumbers.count {
            num = String(playerNumbers[i])
        }
        JSON += num
        JSON += ", \"lives\":"
        JSON += String(3)
        JSON += ", \"killer\":"
        var isKiller = "false"
        JSON += isKiller
        JSON += "}"
        if i != (playerNames.count - 1) {
            JSON += ", "
        }
    }
    JSON += "], \"currentPlayer\":\""
    var playerToShow = "Killer"
    if playerNumbers.count == playerNames.count {
        if playerNames.count != 0 {
            playerToShow = playerNames.first!
        }
    } else if playerNumbers.count > 0 {
        playerToShow = playerNames[playerNumbers.count]
    }
    JSON += playerToShow
    //JSON += players[go].name
    JSON += "\", \"currentTargetName\":\""
    //JSON += currentTargetLabel.text!
    JSON += ""
    JSON += "\", \"currentTargetNumber\":"
    var targetNumber = "\"\""
    JSON += targetNumber
    //JSON += String(players[players[go].tgt[players[go].throw - 1]].num)
    JSON += ", \"targets\":[{\"num\":"
    JSON += "\"\""
    JSON += "}, {\"num\":"
    JSON += "\"\""
    JSON += "}, {\"num\":"
    JSON += "\"\""
    JSON += "}], \"colours\":[{\"num\":"
    JSON += String(0)
    JSON += "}, {\"num\":"
    JSON += String(0)
    JSON += "}, {\"num\":"
    JSON += String(0)
    JSON += "}], \"throw\":"
    JSON += String(1)
    JSON += "}"
    return JSON
}




func post(data: String) {
    if oldData != data {
        var url: NSURL = NSURL(string: "http://www.joehicks.co.uk/killer/updatejson.php")!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        var bodyData = "json=\(data)"
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                //println(response)
                if let HTTPResponse = response as? NSHTTPURLResponse {
                    
                    let statusCode = HTTPResponse.statusCode
                    
                    
                    
                    if statusCode == 200 {
                        
                        // Yes, Do something.
                        
                    }
                    
                }
        }

    } else {
        println("nothing new to change")
    }
    
}

