//
//  ViewController.swift
//  Killer
//
//  Created by Joe Hicks on 25/05/2015.
//  Copyright (c) 2015 Joe Hicks. All rights reserved.
//

import UIKit

var playerNames = [String]()
var playerNumbers = [Int]()

var accuracies = [String: Double]()
var hittable = [Int: Double]()
var winner = Player(name: "Winner", num: 69)
var num2id = [Int: Int]()


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let nameCellIdentifier = "NameCell"
    var wasTyping = true
    @IBOutlet weak var nameTable: UITableView!
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var doneButtonOutlet: UIBarButtonItem!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameInputField.becomeFirstResponder()
        nameInputField.delegate = self
        nameTable.delegate = self
        nameTable.dataSource = self
        playerNumbers = []
        dispPlayers = []
        var num2id = [Int: Int]()
        post(makePregameJSON())

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    



    @IBAction func screenTapped(sender: AnyObject) {
        nameInputField.resignFirstResponder()
    }
    @IBAction func nameInputEditing(sender: AnyObject) {
        nameTable.editing = false
        editButtonOutlet.title = "Edit"
        editButtonOutlet.style = UIBarButtonItemStyle.Plain
        doneButtonOutlet.title = "Numbers"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion == .MotionShake {
            playerNames = shuffle(playerNames)
            nameTable.reloadData()
            post(makePregameJSON())
        }
    }
    
    
    
    


    
    @IBAction func doneButton(sender: UIBarButtonItem) {
        if nameTable.editing {
            let alertController = UIAlertController(title: "Clear all names", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction) -> Void in
                playerNames = []
                    self.nameTable.reloadData()
                    post(makePregameJSON())
            }))
            presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            if playerNames.count > 1 {
                performSegueWithIdentifier("name2number", sender: nil)
            }
        }
    }
    
    @IBAction func editButton(sender: UIBarButtonItem) {
        if !nameTable.editing {
            editButtonOutlet.title = "Done"
            editButtonOutlet.style = UIBarButtonItemStyle.Done
            doneButtonOutlet.title = "Clear"
            nameInputField.resignFirstResponder()
            nameTable.editing = true
        } else {
            editButtonOutlet.title = "Edit"
            editButtonOutlet.style = UIBarButtonItemStyle.Plain
            doneButtonOutlet.title = "Numbers"
            nameInputField.becomeFirstResponder()
            nameTable.editing = false
        }
    }
    
    func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let c = count(list)
        for i in 0..<(c - 1) {
            let j = Int(arc4random_uniform(UInt32(c - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if nameInputField.text != "" {
            if playerNames.count < 20 {
                playerNames.append(nameInputField.text)
                nameInputField.text = ""
                nameTable.reloadData()
                post(makePregameJSON())
            }
        }
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerNames.count
            
        }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(nameCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = playerNames[row]
        if accuracies[playerNames[row]] != nil {
            cell.detailTextLabel?.text = String(format: "%.0f", accuracies[playerNames[row]]! * 100) + "%"
        } else {
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        var moving = playerNames[sourceIndexPath.row]
        playerNames.removeAtIndex(sourceIndexPath.row)
        playerNames.insert(moving, atIndex: destinationIndexPath.row)
        post(makePregameJSON())
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //println("remove")
        if editingStyle == UITableViewCellEditingStyle.Delete {
            playerNames.removeAtIndex(indexPath.row)
            nameTable.reloadData()
            post(makePregameJSON())
        }
    }
}

class NumbersScreen: UIViewController {

    var barProgress: Float {
        get {
            return Float(playerNumbers.count) / Float(playerNames.count)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("number2name", sender: nil)
        playerNumbers = [Int]()
    }
    
    
    var numberButtons = [UIButton]()
    var nameButtonLabels = [UILabel]()
    var numberButtonAssigned = [Bool]()
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerNumbers = []
        progressBar.progress = 0.0
        undoButtonOutlet.title = ""
        //playerNames = ["Joe","Helen","Katy","Roger"]
        post(makePregameJSON(0, playerNames[0]))
        let iMax = playerNames.count - 3
        nameLabel.text = playerNames[0]
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let numbers = [Int](1...20)
        let w = screenSize.width / 400
        let h = screenSize.height / 600
        let bgBox = UIView()
        bgBox.frame = CGRectMake(0, h * 20, w * 400, h * 600)
        bgBox.backgroundColor = UIColorFromRGB(0x5D0D93)
        self.view.addSubview(bgBox)
        numberButtons.append(UIButton())
        nameButtonLabels.append(UILabel())
        numberButtonAssigned.append(false)
        for n in numbers {
            let margw = 8 * w
            let margh = 8 * h
            let buttonWidth = 90 * w
            let buttonHeight = 83 * h
            let toph = 145 * h
            let m = n - 1
            let x = margw + CGFloat(m % 4) * (buttonWidth + margw)
            let y = toph + CGFloat((m - (m % 4)) / 4) * (buttonHeight + margh)
            let actionString = Selector("buttonAction\(n):")
            numberButtonAssigned.append(false)
            numberButtons.append(UIButton.buttonWithType(UIButtonType.System) as! UIButton)
            numberButtons[n].frame = CGRectMake(CGFloat(x), CGFloat(y), buttonWidth, buttonHeight)
            numberButtons[n].backgroundColor = UIColorFromRGB(0x450071)
            numberButtons[n].setTitle(String(n),forState: UIControlState.Normal)
            numberButtons[n].addTarget(self, action: actionString, forControlEvents: UIControlEvents.TouchUpInside)
            numberButtons[n].titleLabel?.font = UIFont(name: numberButtons[n].titleLabel!.font.fontName, size: 40)
            nameButtonLabels.append(UILabel())
            //nameButtonLabels[n].text = ""
            nameButtonLabels[n].textAlignment = NSTextAlignment.Center
            nameButtonLabels[n].frame = CGRectMake(x + 3 * w, y + 59 * h, 84 * w, 21 * h)
            nameButtonLabels[n].textColor = UIColor.lightGrayColor()
            self.view.addSubview(numberButtons[n])
            self.view.addSubview(nameButtonLabels[n])
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func buttonAction(num:Int) {
        if !numberButtonAssigned[num] {
            numberButtons[num].setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
            playerNumbers.append(num)
            numberButtonAssigned[num] = true
            nameButtonLabels[num].text = playerNames[i]
            //println("\(playerNames[i]) has chosen number \(playerNumbers[i])")
            progressBar.setProgress(barProgress, animated: true)
            i++
            if i < playerNames.count {
                nameLabel.text = playerNames[i]
                post(makePregameJSON())
            } else {
                performSegueWithIdentifier("numbers2score", sender: nil)
            }
            
        }
        if i > 0 {
            undoButtonOutlet.title = "Undo"
        }
    }
    
    @IBOutlet weak var undoButtonOutlet: UIBarButtonItem!
    
    @IBAction func undoButton(sender: UIBarButtonItem) {
        var lastAssigned = playerNumbers[i-1]
        numberButtons[lastAssigned].setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        playerNumbers.removeLast()
        numberButtonAssigned[lastAssigned] = false
        nameButtonLabels[lastAssigned].text = ""
        nameLabel.text = playerNames[i-1]
        progressBar.setProgress(barProgress, animated: true)
        i--
        post(makePregameJSON())
        if i < 1 {
            undoButtonOutlet.title = ""
        }
    }
    
    func buttonAction1(sender:UIButton!) {
        buttonAction(1)
    }
    func buttonAction2(sender:UIButton!) {
        buttonAction(2)
    }
    func buttonAction3(sender:UIButton!) {
        buttonAction(3)
    }
    func buttonAction4(sender:UIButton!) {
        buttonAction(4)
    }
    func buttonAction5(sender:UIButton!) {
        buttonAction(5)
    }
    func buttonAction6(sender:UIButton!) {
        buttonAction(6)
    }
    func buttonAction7(sender:UIButton!) {
        buttonAction(7)
    }
    func buttonAction8(sender:UIButton!) {
        buttonAction(8)
    }
    func buttonAction9(sender:UIButton!) {
        buttonAction(9)
    }
    func buttonAction10(sender:UIButton!) {
        buttonAction(10)
    }
    func buttonAction11(sender:UIButton!) {
        buttonAction(11)
    }
    func buttonAction12(sender:UIButton!) {
        buttonAction(12)
    }
    func buttonAction13(sender:UIButton!) {
        buttonAction(13)
    }
    func buttonAction14(sender:UIButton!) {
        buttonAction(14)
    }
    func buttonAction15(sender:UIButton!) {
        buttonAction(15)
    }
    func buttonAction16(sender:UIButton!) {
        buttonAction(16)
    }
    func buttonAction17(sender:UIButton!) {
        buttonAction(17)
    }
    func buttonAction18(sender:UIButton!) {
        buttonAction(18)
    }
    func buttonAction19(sender:UIButton!) {
        buttonAction(19)
    }
    func buttonAction20(sender:UIButton!) {
        buttonAction(20)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


class ScoreBoard: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var history = [[StructPlayer]]()
    var goHistory = [Int]()
    var hitHistory = [false]
    
    override func viewDidLoad() {
//        for n in (0..<playerNames.count) {
//            testField.text = testField.text + "\(playerNames[n]) has number \(playerNumbers[n])\n"
//        }
        super.viewDidLoad()
        scoreboardTableView.delegate = self
        scoreboardTableView.dataSource = self
        let scoreboardCellIdentifier = "ScoreboardCell"
        /*playerNames = ["Joe","Katy","Roger","Helen","Chloe","Peter","Jake","Michael"]
        playerNumbers = [13,14,6,8,19,10,2,4]*/
        //players = [Player]()
        for j in 0..<playerNames.count {
            players.append(Player(name: playerNames[j], num: playerNumbers[j]))
        }
        setup()
        currentTargetLabel.text = players[0].name
        players[0].targets(1)
        targetNumberLabel.text = String(players[0].num)
        dartCount(0)
        updateNumbers(false, player: players[0])
        currentTargetLabel.text = "Yourself"
        currentTargetLabel.font = UIFont.italicSystemFontOfSize(18)
        currentPlayerLabel.text = players[0].name
        //hitHistory.append(false)
        undoGoButton.enabled = false
        post(makePregameJSON(players[0].num, players[0].name, [players[0].num, players[0].num, players[0].num]))
        
        startTurn()
        //players[0].killer = true
        //players[2].lives = 2
    }
    @IBOutlet var scoreboardTableView: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = scoreboardTableView.dequeueReusableCellWithIdentifier("ScoreboardCell", forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = players[row].name
        cell.detailTextLabel?.text = String(players[row].num)
        var killerString = "N"
        if row == go {
            cell.backgroundColor = UIColorFromRGB(0x5B0099)
            cell.textLabel?.textColor = UIColor.whiteColor()
        } else if row == players[go].tgt[players[go].throw - 1] {
            cell.backgroundColor = UIColorFromRGB(0xFFFF00)
            cell.textLabel?.textColor = UIColor.blackColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
            cell.textLabel?.textColor = UIColor.blackColor()
        }
        if players[row].killer {
            killerString = "K"
        }
        let imageString = killerString + String(players[row].lives)
        cell.imageView?.image = UIImage(named: imageString)
        return cell
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func undoLastGoButton(sender: UIBarButtonItem) {
        
        let oldPlayers = history.removeLast()
        if oldPlayers.count > players.count {
            players.append(Player(name: "", num: 0))
        }
        for n in 0...(oldPlayers.count - 1) {
            players[n].name = oldPlayers[n].name
            players[n].num = oldPlayers[n].num
            players[n].order = oldPlayers[n].order
            players[n].i = oldPlayers[n].i
            players[n].throw = oldPlayers[n].throw
            players[n].killer = oldPlayers[n].killer
            players[n].lives = oldPlayers[n].lives
            players[n].tgt = oldPlayers[n].tgt
            players[n].hits = oldPlayers[n].hits
            players[n].misses = oldPlayers[n].misses
            players[n].timesHit = oldPlayers[n].timesHit
            players[n].timesMissed = oldPlayers[n].timesMissed
            players[n].alive = oldPlayers[n].alive
            players[n].didHit = oldPlayers[n].didHit
            players[n].didTargets = oldPlayers[n].didTargets
        }
        
        go = goHistory.removeLast()
        hitHistory.removeLast()
        prepareScreen(hitHistory.last!)
    }
    @IBAction func hitButton(sender: UIButton) {
        //println(players[go].throw)
        var playersAsStructs = [StructPlayer]()
        for m in 0...(players.count - 1) {
            playersAsStructs.append(players[m].copy())
        }
        history.append(playersAsStructs)
        goHistory.append(go)
        hitHistory.append(true)
        
        
        players[go].dart(true)
        if players.count == 1 {
            winner = players[0]
            performSegueWithIdentifier("scoreboard2winners", sender: nil)
        } else {
            players[go].throw++
            if players[go].throw > 3 {
                endTurn()
            }
            prepareScreen(true)
        }
        


        /*
        //testing simulation with hit chance 20%
        let rand = arc4random_uniform(5)
        if rand == 0 {
            players[go].dart(true)
            if players.count == 1 {
                winner = players[0]
                performSegueWithIdentifier("scoreboard2winners", sender: nil)
            } else {
                players[go].throw++
                if players[go].throw > 3 {
                    endTurn()
                }
                prepareScreen(true)
            }
        } else {
            players[go].dart(false)
            players[go].throw++
            if players[go].throw > 3 {
                endTurn()
            }
            prepareScreen(false)
        }
*/
    }
    
    
    @IBAction func missButton(sender: UIButton) {
        //println(players[go].throw)
        //history.append(players)
        var playersAsStructs = [StructPlayer]()
        for m in 0...(players.count - 1) {
            playersAsStructs.append(players[m].copy())
        }
        history.append(playersAsStructs)
        goHistory.append(go)
        hitHistory.append(false)
        players[go].dart(false)
        players[go].throw++
        if players[go].throw > 3 {
            endTurn()
        }
        prepareScreen(false)
    }
    
    
    @IBOutlet weak var currentPlayerLabel: UILabel!
    @IBOutlet weak var currentTargetLabel: UILabel!
    @IBOutlet weak var targetNumberLabel: UILabel!
    @IBOutlet weak var dart1Image: UIImageView!
    @IBOutlet weak var dart2Image: UIImageView!
    @IBOutlet weak var dart3Image: UIImageView!
    @IBOutlet weak var firstNumberLabel: UILabel!
    @IBOutlet weak var secondNumberLabel: UILabel!
    @IBOutlet weak var thirdNumberLabel: UILabel!
    @IBOutlet weak var undoGoButton: UIBarButtonItem!
    
    func prepareScreen(hit:Bool) {
        let fontSize:CGFloat = 18
        
        //println("players[go].throw - 1 = \(players[go].throw - 1)")
        //println(go)
        //println(players[go])
        if players[go].tgt[players[go].throw - 1] != go {
            currentTargetLabel.text = players[players[go].tgt[players[go].throw - 1]].name
            currentTargetLabel.font = UIFont.systemFontOfSize(fontSize)
        } else {
            currentTargetLabel.text = "Yourself"
            currentTargetLabel.font = UIFont.italicSystemFontOfSize(fontSize)
        }
        
        //println("players[go].tgt[players[go].throw - 1] = \(players[go].tgt[players[go].throw - 1])")
        //println("players[go].throw - 1 = \(players[go].throw - 1)")
        targetNumberLabel.text = String(players[players[go].tgt[players[go].throw - 1]].num)
        currentPlayerLabel.text = players[go].name
        dartCount(players[go].throw)
        updateNumbers(hit, player: players[go])
        if history.count == 0 {
            undoGoButton.enabled = false
        } else {
            undoGoButton.enabled = true
        }
        scoreboardTableView.reloadData()
        disp()
        post(makeJSON())
    }
    func dartCount(throw: Int) {
        var dartDisplayArray = ["yellowdartsmall", "yellowdartsmall", "yellowdartsmall"]
        
        if throw > 1 {
            for n in 0...(throw - 2) {
                dartDisplayArray[n] = "greydartsmall"
            }
        }
        
        dart1Image.image = UIImage(named: dartDisplayArray[0])
        dart2Image.image = UIImage(named: dartDisplayArray[1])
        dart3Image.image = UIImage(named: dartDisplayArray[2])
        
    }
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Exit", message: "Are you sure you want to quit this game?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction) -> Void in
            self.performSegueWithIdentifier("scoreboard2names", sender: nil)
            players = [Player]()
            post(makePregameJSON())
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }
    func updateNumbers(hit: Bool, player:Player) {
        var dic = [Int:UIColor]()
        var nums = ["","",""]
        dic.updateValue(UIColor.lightGrayColor(), forKey: 0)
        dic.updateValue(UIColorFromRGB(0xFFFF00), forKey: 1)
        dic.updateValue(UIColor.blackColor(), forKey: 2)
        var throw = player.throw
        for k in 0...2 {
            if player.didTargets[k] == 0 {
                nums[k] = String(players[player.tgt[k]].num)
            } else {
                nums[k] = String(player.didTargets[k])
            }
        }
        firstNumberLabel.text = nums[0]
        secondNumberLabel.text = nums[1]
        thirdNumberLabel.text = nums[2]
        firstNumberLabel.textColor = dic[player.didHit[0]]
        secondNumberLabel.textColor = dic[player.didHit[1]]
        thirdNumberLabel.textColor = dic[player.didHit[2]]
    }
    func startTurn() {
        //highlight player
        disp()
        players[go].targets(1)
        players[go].didHit = [1, 1, 1]
        players[go].didTargets = [0, 0, 0]
        players[go].throw = 1
        //highlight target
    }
    func endTurn() {
        players[go].throw = 0
        players[go].didHit = [1, 1, 1]
        players[go].didTargets = [0, 0, 0]
        go = (go + 1) % players.count
        startTurn()
    }
    
    func makeJSON() -> String {
        var JSON:String = "{\"players\":["
        for player in dispPlayers {
            JSON += "{\"name\":\""
            JSON += player.name
            JSON += "\", \"num\":"
            JSON += String(player.num)
            JSON += ", \"lives\":"
            JSON += String(player.lives)
            JSON += ", \"killer\":"
            var isKiller: String
            if player.killer {
                isKiller = "true"
            } else {
                isKiller = "false"
            }
            JSON += isKiller
            JSON += "}"
            if player.num != dispPlayers.last?.num {
                JSON += ", "
            }
        }
        JSON += "], \"currentPlayer\":\""
        JSON += currentPlayerLabel.text!
        //JSON += players[go].name
        JSON += "\", \"currentTargetName\":\""
        //JSON += currentTargetLabel.text!
        var targetText = players[players[go].tgt[players[go].throw - 1]].name
        if targetText == currentPlayerLabel.text! {
            targetText = "Yourself"
        }
        JSON += targetText
        JSON += "\", \"currentTargetNumber\":"
        JSON += targetNumberLabel.text!
        //JSON += String(players[players[go].tgt[players[go].throw - 1]].num)
        JSON += ", \"targets\":[{\"num\":"
        JSON += firstNumberLabel.text!
        JSON += "}, {\"num\":"
        JSON += secondNumberLabel.text!
        JSON += "}, {\"num\":"
        JSON += thirdNumberLabel.text!
        JSON += "}], \"colours\":[{\"num\":"
        JSON += String(players[go].didHit[0])
        JSON += "}, {\"num\":"
        JSON += String(players[go].didHit[1])
        JSON += "}, {\"num\":"
        JSON += String(players[go].didHit[2])
        JSON += "}], \"throw\":"
        JSON += String(players[go].throw)
        JSON += "}"
        return JSON
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

class WinnerScreen: UIViewController {
    
    @IBAction func screenTap(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("winner2names", sender: nil)
        players = [Player]()
    }
    @IBOutlet weak var winnerLabel: UILabel!
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        for player in dispPlayers {
            var acc = 0.00
            var hit = 0.00
            if player.misses + player.hits != 0 {
                acc = Double(player.hits) / Double(player.misses + player.hits)
                hit = Double(player.timesHit) / Double(player.timesMissed + player.timesHit)
            }
            
            accuracies.updateValue(acc, forKey: player.name)
            hittable.updateValue(hit, forKey: player.num)
            //println("\(player.name) has \(accuracies[player.name])")
        }
        winnerLabel.text = winner.name
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


