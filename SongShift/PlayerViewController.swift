//
//  PlayerViewController.swift
//  SongShift
//
//  Created by Jayaditya Vinay Singhvi on 31/03/25.
//
import AVFoundation
import UIKit

class PlayerViewController: UIViewController {
    public var position: Int = 0
    public var songs: [Song] = []
    
    @IBOutlet var holder: UIView!
    
    var player: AVAudioPlayer?
    //User Interface elements
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 //Allows line wrapping
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 //Allows line wrapping
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 //Allows line wrapping
        return label
    }()
    let playPauseButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0
        {
            configure()
        }
    }
    
    func configure()
    {
        let song = songs[position]
        let urlString = Bundle.main.path(forResource: song.trackname, ofType: "mp3")
        do
        {
           try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true,options: .notifyOthersOnDeactivation)
            guard let urlString = urlString else
            {
                return
            }
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            guard let player = player else
            {
                return
            }
            player.volume = 0.5
            player.play()
        }
        catch
        {
            print("error occured") 
        }
        
        //album cover
        albumImageView.frame = CGRect(x: 10, y: 10, width: holder.frame.size.width - 20, height: holder.frame.width - 20)
        albumImageView.image = UIImage(named: song.albumcover)
        holder.addSubview(albumImageView)
        //Labels (sonng name,album,artist)
        songNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height+10, width: holder.frame.size.width - 20, height: 70)
        artistNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height+10+50, width: holder.frame.size.width - 20, height: 70)
        albumNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height+10+100, width: holder.frame.size.width - 20, height: 70)
        
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumname
        artistNameLabel.text = song.artistname
        
        
        holder.addSubview(songNameLabel)
        holder.addSubview(albumNameLabel)
        holder.addSubview(artistNameLabel)
        
        //Player controls
        let forwardButton = UIButton()
        let previousButton = UIButton()
        
        //Frames
        let ypos = artistNameLabel.frame.origin.y + 150
        let size: CGFloat = 60
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size)/2.0, y: ypos, width: size, height: size)
        forwardButton.frame = CGRect(x: holder.frame.size.width - size - 40, y: ypos, width: size, height: size)
        previousButton.frame = CGRect(x: 40, y: ypos, width: size, height: size)
        
        
        //Adding Actions to Button
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForwardButton), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(didTapPreviouisButton), for: .touchUpInside)
        
        //Images for the buttons
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        forwardButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        previousButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        playPauseButton.tintColor = .black
        forwardButton.tintColor = .black
        previousButton.tintColor = .black
        
        holder.addSubview(playPauseButton)
        holder.addSubview(forwardButton)
        holder.addSubview(previousButton)
        
        
        // Slider
        let slider = UISlider(frame: CGRect(x: 20, y: holder.frame.size.height-60, width: holder.frame.size.width - 40, height: 50))
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlideslider(_:)), for: .valueChanged)
        holder.addSubview(slider)
        
    }
    
    @objc func didTapPreviouisButton()
    {
        if position > 0
        {
            position = position - 1
            player?.stop()
            for subview in holder.subviews
            {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapForwardButton()
    {
        if position < songs.count - 1
        {
            position = position + 1
            player?.stop()
            for subview in holder.subviews
            {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapPlayPauseButton()
    {
        if (player?.isPlaying == true)
        {
            player?.pause()
            //Change Button Image
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            //Shrink album cover for animations
            UIView.animate(withDuration: 0.2)
            {
                self.albumImageView.frame = CGRect(x: 50, y: 50, width: self.holder.frame.size.width - 100, height: self.holder.frame.width - 100)
            }
        }
        else
        {
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            //Enlarge image back to normal
            UIView.animate(withDuration: 0.2)
            {
                self.albumImageView.frame = CGRect(x: 10, y: 10, width: self.holder.frame.size.width - 20, height: self.holder.frame.width - 20)
            }
        }
    }
    
    @objc func didSlideslider(_ slider: UISlider)
    {
        let value = slider.value
        player?.volume = value
        //Adjusting volume
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player
        {
            player.stop()
        }
    }

}
