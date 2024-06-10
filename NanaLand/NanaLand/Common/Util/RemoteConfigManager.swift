//
//  RemoteConfigManager.swift
//  NanaLand
//
//  Created by 정현우 on 6/10/24.
//

import Foundation
import FirebaseRemoteConfig

class RemoteConfigManager {
	var remoteConfig = RemoteConfig.remoteConfig()
	var settings = RemoteConfigSettings()
	
	// MARK: - RemoteConfig 리스너 설정
	func setupRemoteConfigListener() {
		self.settings.minimumFetchInterval = 0
		self.remoteConfig.configSettings = settings
		remoteConfig.addOnConfigUpdateListener { configUpdate, error in
			if let error {
				print("Error: \(error)")
				return
			}
		}
	}
	
	func getMinimumVersion() async -> String? {
		setupRemoteConfigListener()
		do {
			try await remoteConfig.fetch()
			try await remoteConfig.activate()
			return self.remoteConfig["ios_version"].stringValue
		} catch {
			print("Error: \(error)")
			return nil
		}
	}
	
	// 업데이트가 필요하면 true를, 필요없다면 false를
	func checkUpdateRequired(minimumVersion: String) -> Bool {
		guard let currentVersion = Bundle.main.infoDictionary? ["CFBundleShortVersionString"] as? String else {
			return false
		}
		
		// 버전 문자열을 '.'을 기준으로 나누어 배열로 변환
		let minimumVersionComponents = minimumVersion.split(separator: ".").map { Int($0) ?? 0 }
		let currentVersionComponents = currentVersion.split(separator: ".").map { Int($0) ?? 0 }
		
		// 두 배열의 길이를 맞추기 위해 짧은 배열에 0 추가
		let maxLength = max(minimumVersionComponents.count, currentVersionComponents.count)
		let paddedMinimumVersion = minimumVersionComponents + Array(repeating: 0, count: maxLength - minimumVersionComponents.count)
		let paddedCurrentVersion = currentVersionComponents + Array(repeating: 0, count: maxLength - currentVersionComponents.count)
		
		// 각 버전 숫자를 비교
		for (min, cur) in zip(paddedMinimumVersion, paddedCurrentVersion) {
			if cur < min {
				return true // 업데이트가 필요함
			} else if cur > min {
				return false // 업데이트가 필요하지 않음
			}
		}
		
		return false // 두 버전이 같음
		
	}
}
