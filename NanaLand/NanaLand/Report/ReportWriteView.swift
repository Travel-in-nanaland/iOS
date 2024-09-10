//
//  ReportWriteView.swift
//  NanaLand
//
//  Created by juni on 8/24/24.
//

import SwiftUI
import _PhotosUI_SwiftUI
import CustomAlert

struct ReportWriteView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizationManager: LocalizationManager
    @State var text: String = ""
    @State var emailText: String = UserDefaults.standard.string(forKey: "UserEmail")!
    @ObservedObject var viewModel = ReportWriteViewModel()
    @State private var reportContent: String = ""
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var reasonValidate: Bool = false
    @State private var emailValidate: Bool = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImageData: [Data] = []
    @State private var emailTextFieldDisabled: Bool = false
    @State private var isLoading: Bool = false
    @State private var emailTextWarning: Bool = false
    @Binding var isReport: Bool
    @State var showAlert = false //뒤로가기 alert 여부
    var claimType: String // 신고 목적
    var id: Int64
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    NanaNavigationBar(title: .report, showBackButton: false)
                        .padding(.bottom, 24)
                    HStack(spacing: 0) {
                        Button(action: {
                            withAnimation(nil) {
                                showAlert = true
                            }
                 
                        }, label: {
                            Image("icLeft")
                                .renderingMode(.template)
                                .foregroundStyle(Color.black)
                        })
                        .fullScreenCover(isPresented: $showAlert) {
                            AlertView(title: .reviewBackAlertTitle, message: .reviewBackAlertMessage, leftButtonTitle: .yes, rightButtonTitle: .no, leftButtonAction: {
                                showAlert = false
                            }, rightButtonAction: {
                                showAlert = false
                                dismiss()
                            })
                        }
                        .transaction { transaction in
                            transaction.disablesAnimations = true
                        }
                        .padding(.leading, 16)
                        Spacer()
                    }
                    .padding(.bottom, 12)
                }
          
                
                ScrollView {
                    VStack(spacing: 0) {
   
                        HStack(spacing: 0) {
                            Text("신고사유")
                                .padding(.trailing, 12)
                                .font(.title02_bold)
                            Text("*필수")
                                .foregroundStyle(.main)
                                .font(.caption01)
                            Spacer()
                        }
                        .padding(.leading, 16)
                        .padding(.bottom, 8)
                        TextEditor(text: $text)
                            .font(.body02)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke((text.count < 20 && text.count > 0) ? Color.red : Color.gray2, lineWidth: 1)
                            )
                            .overlay(alignment: .topLeading) {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text("신고 사유를 20자 이상 작성해 주세요.")
                                            .foregroundStyle(text.isEmpty ? .gray : .clear)
                                            .font(.body02)
                                            .padding(.top, 8)
                                            .padding(.leading, 8)
                                        Spacer()
                                    }
                                    Spacer()
                                    HStack(spacing: 0) {
                                        Spacer()
                                        Text("(\(text.count)/500)")
                                            .font(.body02)
                                            .foregroundStyle(Color.gray1)
                                            .padding(.trailing, 10)
                                            .padding(.bottom, 5)
                                    }
                                }
                             
                            }
                            .onChange(of: text) { newValue in
                                viewModel.state.reportDTO.content = newValue
                                print("\(newValue)")
                                if newValue.count > 500 {
                                    text = String(newValue.prefix(500))
                                    toastMessage = "내용은 500자 이내로 작성 가능합니다"
                                    showToast = true
                                    reasonValidate = false
                                }
                                else if 20 <= newValue.count && newValue.count <= 500 {
                                    reasonValidate = true
                                    emailTextFieldDisabled = false
                                } else {
                                    reasonValidate = false
                                    emailTextFieldDisabled = true
                                }
                            }
                            .frame(width: Constants.screenWidth - 32, height: 120)
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                            .padding(.bottom, 8)
                        if (text.count > 0 && text.count < 20) {
              
                            HStack(spacing: 0) {
                                Image("icWarning")
                                Text("신고 사유는 20자 이상으로 입력해주세요.")
                                    .font(.caption01)
                                    .foregroundStyle(.red)
                                Spacer()
                            }
                            .padding(.leading, 16)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text("이메일")
                                .padding(.trailing, 12)
                                .font(.title02_bold)
                            Text("*필수")
                                .foregroundStyle(.main)
                                .font(.caption01)
                            Spacer()
                        }
                        .padding(.leading, 16)
                        .padding(.bottom, 8)
                        HStack(spacing: 0) {
                            Text("신고 결과를 받을 이메일을 입력해주세요.")
                                .font(.body02)
                                .foregroundStyle(Color.gray1)
                                
                            Spacer()
                        }
                        .padding(.bottom, 8)
                        .padding(.leading, 16)
                        VStack(spacing: 0) {
                            
                            TextField("aaaaaaaaaa@naver.com", text: $emailText)
                                .padding()
                                .cornerRadius(8)
                                .frame(height: 48)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray2, lineWidth: 1)
                                )
                                .disabled(emailTextFieldDisabled)
                                .onChange(of: emailText) { newValue in
                                    if !isValidEmail(newValue) {
                                        emailTextWarning = true
                                    } else {
                                        emailTextWarning = false
                                    }
                                }
                                .padding(.bottom, 4)
                            HStack(spacing: 0) {
                                if (emailTextWarning) {
                                    Text("*올바른 이메일을 입력해주세요.")
                                        .foregroundStyle(.red)
                                        .font(.caption01)
                                }
                                Spacer()
                            }
                            
                        }
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .padding(.bottom, 44)
                        
                      
                        HStack(spacing: 0) {
                            Text("사진 / 동영상")
                                .font(.title02_bold)
                            Spacer()
                        }
                        .padding(.leading, 16)
                        .padding(.bottom, 7)
                        
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray2)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                                    .padding(.leading, -5)
                                
                                PhotosPicker(
                                    selection: $selectedItems,
                                    maxSelectionCount: 5,
                                    matching: .images,
                                    photoLibrary: .shared()
                                ) {
                                    if viewModel.state.imgCnt == 5{
                                        Button { // 사진이 5장인 상태(최대상태) 에서 또 클릭 할 시 토스트 메시지 띄우기
                                            toastMessage = "사진은 최대 5장까지 선택 가능합니다"
                                            showToast = true
                                        } label: {
                                            VStack {
                                                Image(systemName: "camera")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 26)
                                                Text("\(viewModel.state.imgCnt) / 5")
                                                    .font(.gothicNeo(.light, size: 15))
                                            }
                                            .foregroundColor(.white)
                                        }
                                    }
                                    else {
                                        VStack {
                                            Image(systemName: "camera")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 26)
                                            Text("\(viewModel.state.imgCnt) / 5")
                                                .font(.gothicNeo(.light, size: 15))
                                        }
                                        .foregroundColor(.white)
                                    }
                                }
                                .padding(.leading, -5)
                            }
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(Array(selectedImageData.enumerated()), id: \.element) { index, imageData in
                                        if let uiImage = UIImage(data: imageData) {
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .frame(width: 80, height: 80)
                                                    .cornerRadius(8)
                                                
                                                Button(action: {
                                                    selectedImageData.remove(at: index)
                                                    selectedItems.remove(at: index)
                                                    viewModel.updateImageCount(selectedImageData.count)
                                                }) {
                                                    Image("icRemovePhoto")
                                                        .padding(.trailing, 2)
                                                        .padding(.top, 2)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                    }
                }
                .onChange(of: selectedItems) { newItems in
                    Task {
                        selectedImageData.removeAll()
                        for newItem in newItems {
                            if let data = try? await newItem.loadTransferable(type: Data.self) {
                                if selectedImageData.count < 5 {
                                    selectedImageData.append(data) // 선택된 이미지 추가
                                }
                            }
                        }
                        viewModel.updateImageCount(selectedImageData.count)
                    }
                }
                Spacer()
                Button {
                    Task {
                        isLoading = true
                        await postReport(body: viewModel.state.reportDTO, multipartFile: selectedImageData)
                        isLoading = false
                        isReport = true
                        AppState.shared.navigationPath.removeLast()
                        AppState.shared.navigationPath.removeLast()
                    }
                } label: {
                    Text("보내기")
                        .foregroundStyle(Color.white)
                }
                .frame(width: Constants.screenWidth - 32, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(reasonValidate && !emailTextWarning && emailText.count != 0 ? Color.main : Color.main10P)
                )
                .disabled(!reasonValidate || emailTextWarning || emailText.count == 0)
                .padding(.bottom, 24)
             
            }
            .overlay(
                Toast(message: toastMessage, isShowing: $showToast, isAnimating: true)
            )
            .toolbar(.hidden)
            .onAppear {
                isReport = true
                viewModel.state.reportDTO.id = Int(id)
                switch claimType {
                case "영리목적 / 홍보성":
                    viewModel.state.reportDTO.claimType = "COMMERCIAL_PURPOSE"
                case "마음에 들지 않습니다":
                    viewModel.state.reportDTO.claimType = "DISLIKE"
                case "욕설/인신공격":
                    viewModel.state.reportDTO.claimType = "PROFANITY"
                case "개인정보 노출":
                    viewModel.state.reportDTO.claimType = "PERSONAL_INFORMATION"
                case "음란 / 선정성":
                    viewModel.state.reportDTO.claimType = "OBSCENITY"
                case "시설 폐업 및 다른 시설에 대한 리뷰":
                    viewModel.state.reportDTO.claimType = "FACILITY_ISSUE"
                case "약물":
                    viewModel.state.reportDTO.claimType = "DRUGS"
                case "학대 / 폭력":
                    viewModel.state.reportDTO.claimType = "VIOLENCE"
                case "기타":
                    viewModel.state.reportDTO.claimType = "ETC"
                default:
                    viewModel.state.reportDTO.claimType = "ETC"
                }
            }
            if isLoading {
                ProgressView() // 로딩 중에는 ProgressView를 표시
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5)) // 배경색
                    .edgesIgnoringSafeArea(.all) // 전체 화면을 덮도록 설정
            }
        }
    }
    
    func postReport(body: ReportDTO, multipartFile: [Foundation.Data?]) async {
        await viewModel.action(.postReport(body: body, multipartFile: multipartFile))
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}

//#Preview {
//    ReportWriteView(text: "abc", claimType: "aa", id: 0)
//}
