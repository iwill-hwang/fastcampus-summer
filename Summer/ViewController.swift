//
//  ViewController.swift
//  Summer
//
//  Created by donghyun on 2021/05/30.
//

import UIKit

extension UIImage {
    func createFilteredImage(filterName: String, intensity: Double = 1) -> UIImage {
        let context = CIContext(options: nil)
        let source = CIImage(image: self)

        let filter = CIFilter(name: filterName)
        
        filter?.setDefaults()
        filter?.setValue(source, forKey: kCIInputImageKey)
//        filter?.setValue(intensity, forKey: kCIInputIntensityKey)
        
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)

        let filteredImage = UIImage(cgImage: outputCGImage!)

        return filteredImage
    }
}

class FilterItemCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

struct Filter {
    let name: String
    let identifier: String
}

final class FilterManager {
    let filters = [
        Filter(name: "Vivid", identifier: "CIPhotoEffectChrome"),
        Filter(name: "Fade", identifier: "CIPhotoEffectFade"),
        Filter(name: "Instant", identifier: "CIPhotoEffectInstant"),
        Filter(name: "Mono", identifier: "CIPhotoEffectMono"),
        Filter(name: "Noir", identifier: "CIPhotoEffectNoir"),
        Filter(name: "Process", identifier: "CIPhotoEffectProcess"),
        Filter(name: "Tonal", identifier: "CIPhotoEffectTonal"),
        Filter(name: "Transfer", identifier: "CIPhotoEffectTransfer"),
        Filter(name: "Curve", identifier: "CILinearToSRGBToneCurve"),
        Filter(name: "Linear", identifier: "CISRGBToneCurveToLinear")
    ]
}

class ViewController: UIViewController {
    private let filterManager = FilterManager()
    private var originalImage: UIImage = UIImage(named: "Sample")!
    private var selectedIndex: Int?
    
    private lazy var thumbnails: [UIImage] = {
        filterManager.filters.map{UIImage(named: "Thumbnail")!.createFilteredImage(filterName: $0.identifier)}
    }()
    
    @IBOutlet weak private var photoView: UIImageView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoView.image = originalImage
        self.photoView.layer.cornerRadius = 4
        self.photoView.layer.masksToBounds = true
        self.photoView.layer.cornerCurve = .continuous
    }
    
    @IBAction func importPhoto() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func save() {
        let controller = UIAlertController(title: "저장되었습니다", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[.originalImage] as? UIImage {
            self.photoView.image = photo
            self.originalImage = photo
            self.selectedIndex = nil
            self.collectionView.reloadData()
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
        
        cell.imageView.image = thumbnails[indexPath.row]
        cell.titleLabel.textColor = indexPath.item == selectedIndex ? .black : .lightGray
        cell.titleLabel.text = filterManager.filters[indexPath.item].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filterManager.filters[indexPath.item]
        
        let filteredImage = originalImage.createFilteredImage(filterName: filter.identifier)
        
        self.photoView.image = filteredImage
        
        self.selectedIndex = indexPath.item
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 100)
    }
}
