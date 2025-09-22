//
//  ViewController.swift
//  SongShift
//
//  Created by Jayaditya Vinay Singhvi on 31/03/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSongs()
        table.delegate = self
        table.dataSource = self
        
    }
    
    func configureSongs()
    {
        songs.append(Song(name: "Something",
                          albumname: "Abbey Road",
                          artistname: "The Beatles",
                          albumcover: "cover1",
                          trackname: "song1"))
        songs.append(Song(name: "Another One",
                          albumname: "Another One",
                          artistname: "Mac DeMarco",
                          albumcover: "cover2",
                          trackname: "song2"))
        songs.append(Song(name: "Mojo Pin",
                          albumname: "Grace",
                          artistname: "Jeff Buckley",
                          albumcover: "cover3",
                          trackname: "song3"))
        songs.append(Song(name: "The Adults are Talking",
                          albumname: "The New Abnormal",
                          artistname: "The Strokes",
                          albumcover: "cover4",
                          trackname: "song4"))
        songs.append(Song(name: "Memory Box",
                          albumname: "Bismillah",
                          artistname: "PCRC",
                          albumcover: "cover5",
                          trackname: "song5"))
    }
        
  
    
    // Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumname
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: song.albumcover)
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)

        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {  //Sets heiight as images were too small
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Present the player
        let position = indexPath.row
        //songs
        guard let vc = storyboard?.instantiateViewController(withIdentifier:"player") as? PlayerViewController else {
            return
        }
        vc.songs = songs
        vc.position = position
        present(vc, animated: true)
        
    }


}

struct Song {
    let name: String
    let albumname: String
    let artistname: String
    let albumcover: String
    let trackname: String
}

