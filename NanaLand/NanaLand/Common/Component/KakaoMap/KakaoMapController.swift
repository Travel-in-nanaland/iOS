//
//  KakaoMap.swift
//  NanaLand
//
//  Created by wodnd on 2/24/25.
//

import Foundation
import SwiftUI
import KakaoMapsSDK

struct KakaoMapController: UIViewRepresentable {
    @Binding var draw: Bool
    @Binding var coordinate: (Double, Double)  // 🔴 변환된 좌표 저장
    
    func makeUIView(context: Self.Context) -> KMViewContainer {
        let view = KMViewContainer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        context.coordinator.createController(view)
        return view
    }
    
    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        print("🔄 updateUIView 호출됨. 현재 draw 상태: \(draw)")
        if draw {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                guard let controller = context.coordinator.controller else {
                    print("❌ controller가 nil 상태입니다. updateUIView에서 실행할 수 없습니다.")
                    return
                }

                if !controller.isEnginePrepared {
                    print("⚠️ 엔진 준비되지 않음. 준비 시작.")
                    controller.prepareEngine()
                }

                if !controller.isEngineActive {
                    print("⚠️ 엔진 비활성화됨. 활성화 시작.")
                    controller.activateEngine()
                }

                // ✅ 지도 이동 (좌표가 업데이트된 경우)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let mapView = controller.getView("mapview") as? KakaoMap {
                        print("🗺️ mapView 가져오기 성공")
                        let cameraUpdate = CameraUpdate.make(target: MapPoint(longitude: coordinate.0, latitude: coordinate.1), mapView: mapView)
                        mapView.moveCamera(cameraUpdate)
                        print("✅ 지도 이동 완료: \(coordinate.0), \(coordinate.1)")
                        
                        // 🟢 새로운 마커 핀 추가
                        context.coordinator.addMarker(at: coordinate, to: mapView)
                    } else {
                        print("⚠️ mapView가 nil입니다. 지도 뷰가 추가되었는지 확인하세요.")
                    }
                }
            }
        } else {
            print("🛑 지도 엔진 중지됨")
            context.coordinator.controller?.pauseEngine()
            context.coordinator.controller?.resetEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator()
    }
    
    class KakaoMapCoordinator: NSObject, MapControllerDelegate {
        var controller: KMController?
        var container: KMViewContainer?

        func createController(_ view: KMViewContainer) {
            print("🟢 createController 호출됨")
            container = view
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }

        func addViews() {
            guard let controller = controller else {
                print("❌ controller가 nil입니다. addView를 실행할 수 없습니다.")
                return
            }

            let defaultPosition = MapPoint(longitude: 126.529124, latitude: 33.362418)
            let mapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
            controller.addView(mapviewInfo)
        }

        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            print("✅ 지도 뷰 추가 성공: \(viewName)")
            let view = controller?.getView("mapview")
            view?.viewRect = container!.bounds
        }
        
        func addMarker(at coordinate: (Double, Double), to mapView: KakaoMap) {
            let defaultCoordinate: (Double, Double) = (126.529124, 33.362418) // 기본 위치
            if coordinate == defaultCoordinate {
                print("⚠️ 기본 위치에서는 마커 추가 안 함")
                return
            }

            print("📍 마커 추가: \(coordinate.0), \(coordinate.1)")

            let manager = mapView.getLabelManager()

            // 🔴 LabelLayer가 있는지 확인 후 없으면 추가
            if manager.getLabelLayer(layerID: "PoiLayer") == nil {
                print("⚠️ LabelLayer가 없음. 새로 추가합니다.")
                let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 100000)
                manager.addLabelLayer(option: layerOption)
            }

            let poiOption = PoiOptions(styleID: "CustomMarkerStyle")
            let layer = manager.getLabelLayer(layerID: "PoiLayer")

            guard let poi = layer?.addPoi(option: poiOption, at: MapPoint(longitude: coordinate.0, latitude: coordinate.1)) else {
                print("❌ 마커 추가 실패: addPoi()가 nil 반환")
                return
            }

            if let originalImage = UIImage(named: "logoPin") {
                let resizedImage = originalImage.resize(to: CGSize(width: 35, height: 35))
                let badge = PoiBadge(badgeID: "marker", image: resizedImage, offset: CGPoint(x: 0, y: -20), zOrder: 1)
                poi.addBadge(badge)
                poi.show()
                poi.showBadge(badgeID: "marker")
            } else {
                print("⚠️ 이미지 로드 실패: custom_marker.png")
            }
        }
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
