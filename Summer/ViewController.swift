//
//  ViewController.swift
//  Summer
//
//  Created by donghyun on 2021/05/30.
//

import UIKit

extension UIImage {
    func createFilteredImage(filterName: String, image: UIImage) -> UIImage {
        let context = CIContext(options: nil)
        let source = CIImage(image: image)

        let filter = CIFilter(name: filterName)
        
        filter?.setDefaults()
        filter?.setValue(source, forKey: kCIInputImageKey)

        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)

        // 5 - convert filtered CGImage to UIImage
        let filteredImage = UIImage(cgImage: outputCGImage!)

        return filteredImage
    }
}

class FilterItemCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}


final class FilterManager {
    var filters = [
        "No Filter",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CILinearToSRGBToneCurve",
        "CISRGBToneCurveToLinear"
    ]
}

class ViewController: UIViewController {
    private let filterManager = FilterManager()
    private var originalImage: UIImage?
    
    @IBOutlet weak private var photoView: UIImageView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func importPhoto() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[.originalImage] as? UIImage {
            self.photoView.image = photo
            self.originalImage = photo
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterManager.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterItemCell", for: indexPath) as! FilterItemCell
        let sample = UIImage(named: "Sample")!
        
        var image = sample
        
        if indexPath.row > 0 {
            image = sample.createFilteredImage(filterName: filterManager.filters[indexPath.row], image: sample)
        }
        
        cell.imageView.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filterManager.filters[indexPath.item]
        if let image = originalImage {
            let filteredImage = image.createFilteredImage(filterName: filter, image: image)
            self.photoView.image = filteredImage
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.height)
    }
}
