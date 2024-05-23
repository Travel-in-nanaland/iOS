//
//  ArticleDetailViewType.swift
//  NanaLand
//
//  Created by 정현우 on 5/23/24.
//

import Foundation

// shop, nature등 리스트에서 detail과 정보 수정 제안으로 navigation
enum ArticleViewType: Hashable {
	case detail(id: Int64)
	case reportInfo(id: Int64, category: Category)
}
