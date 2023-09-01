//
//  SignUpView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var showNameField = false
    @State private var showStudentNoField = false
    @State private var showPhoneField = false
    @State private var showNickNamefield = false
    @State private var showIDCard = false
    @State private var showEULAArea = false
    
    @State private var text = ""
    @State private var name = ""
    @State private var studentNo = ""
    @State private var phone = ""
    @State private var nickName = ""
    @State private var pickedImage : Image?
    
    @State private var isNameEditing = false
    @State private var isStudentNoEditing = false
    @State private var isPhoneEditing = false
    @State private var isNickNameEditing = false
    
    @State private var acceptLicense = false
    @State private var acceptPrivacy = false
    @State private var acceptMarketing = false
    
    @State private var showAlert = false
    @State private var showPicker = false
    @State private var showLicense = false
    @State private var showActionSheet = false
    @State private var showTutorial = false
    @State private var showProcess = false
    @State private var licenseType : LicenseType = .EULA
    @State private var pickerType : UIImagePickerController.SourceType = .photoLibrary
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentations) private var presentations
    
    private func changeText(text : String){
        withAnimation{
            self.text = text
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.showNameField = true
            self.text = "이름을 입력해주세요."
        })
    }
    
    //    private func openIDCard(){
    //        let url = "https://apps.apple.com/kr/app/%EC%A0%84%EB%B6%81%EB%8C%80%EC%95%B1/id1510698205"
    //
    //        let appURL = URL(string: url)
    //
    //        if UIApplication.shared.canOpenURL(appURL!){
    //            UIApplication.shared.openURL(appURL!)
    //        }
    //    }
    
    //    private func actionSheet() -> ActionSheet{
    //        let buttons = [
    //            ActionSheet.Button.default(Text("학생증 사진 찍기")){
    //                self.showActionSheet = false
    //                self.pickerType = .camera
    //                self.showPicker = true
    //            },
    //
    //            ActionSheet.Button.default(Text("실물/모바일학생증 이미지 불러오기")){
    //                self.showActionSheet = false
    //                self.pickerType = .photoLibrary
    //                self.showPicker = true
    //            },
    //
    //            ActionSheet.Button.default(Text("모바일 학생증앱 열기")){
    //                self.showActionSheet = false
    //                openIDCard()
    //            },
    //
    //            ActionSheet.Button.cancel(Text("취소"))
    //        ]
    //
    //        let actionSheet = ActionSheet(title : Text("학생증 로드 방식 선택"),
    //                                      message: Text("학생증을 불러올 방법을 선택하세요."),
    //                                      buttons: buttons)
    //
    //        return actionSheet
    //    }
    
    var body: some View {
        ScrollView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    Spacer().frame(height : 40)
                    
                    Text(self.text)
                        .font(.title)
                        .fontWeight(.bold)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration:1)))
                    
                    Spacer().frame(height : 40)
                    
                    Group {
                        HStack {
                            Image(systemName: "person.fill.viewfinder")
                            
                            TextField("이름", text:$name, onEditingChanged: {(editing) in
                                if editing{
                                    isNameEditing = true
                                }
                                
                                else{
                                    self.text = "닉네임을 입력해주세요."
                                    isNameEditing = false
                                    showNickNamefield = true
                                }
                                
                            })
                        }
                        .foregroundColor(isNameEditing ? Color.accent : Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                        .isHidden(!showNameField)
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                        
                        Spacer().frame(height : 20)
                        
                        HStack {
                            Image(systemName: "person.fill")
                            
                            TextField("닉네임", text:$nickName, onEditingChanged: {(editing) in
                                if editing{
                                    isNickNameEditing = true
                                }
                                
                                
                                else{
                                    self.text = "연락처를 입력해주세요."
                                    isNickNameEditing = false
                                    showPhoneField = true
                                }
                                
                            })
                        }
                        .foregroundColor(isNickNameEditing ? Color.accent : Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                        .isHidden(!showNickNamefield)
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                        
                        Spacer().frame(height : 20)
                        
                        HStack {
                            Image(systemName: "phone.fill")
                            
                            TextField("휴대폰 번호", text:$phone, onEditingChanged: {(editing) in
                                if editing{
                                    isPhoneEditing = true
                                } else{
                                    self.text = "학번을 입력해주세요."
                                    showStudentNoField = true
                                    isPhoneEditing = false
                                }
                                
                                //                                else{
                                //                                    self.text = "학번을 입력해주세요."
                                //                                    isPhoneEditing = false
                                //                                    showStudentNoField = true
                                //                                }
                            }).keyboardType(.numbersAndPunctuation)
                            
                            Button(action: {}){
                                Text("인증번호 발송")
                                    .foregroundColor(.txt_dark)
                                    .font(.caption)
                            }.padding([.vertical], 5)
                                .padding([.horizontal], 10)
                                .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.btn_dark))
                        }
                        .foregroundColor(isPhoneEditing ? Color.accent : Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                        .isHidden(!showPhoneField)
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Group{
                        HStack {
                            Image(systemName: "person.crop.square.fill.and.at.rectangle")
                            
                            TextField("학번", text:$studentNo, onEditingChanged: {(editing) in
                                if editing{
                                    isStudentNoEditing = true
                                }
                                
                                else{
                                    isStudentNoEditing = false
                                    showEULAArea = true
                                }
                                
                            })
                        }
                        .foregroundColor(isStudentNoEditing ? Color.accent : Color.txt_color)
                        .keyboardType(.numbersAndPunctuation)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                    }.isHidden(!showStudentNoField)
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                    
                    
                    //                    Group{
                    //                        Divider()
                    //
                    //                        HStack {
                    //                            Text("실물 학생증 또는 모바일 학생증을 불러와주세요.")
                    //                                .fontWeight(.bold)
                    //
                    //                            Spacer()
                    //
                    //                        }.padding(10)
                    //
                    //                        Button(action: {
                    ////                            self.showTutorial = true
                    //                            self.pickerType = .photoLibrary
                    //                            self.showPicker = true
                    //
                    //                        }){
                    //                            HStack {
                    //                                Image(systemName: "creditcard.fill")
                    //                                    .foregroundColor(.txt_color)
                    //
                    //                                if self.pickedImage == nil{
                    //                                    Text("학생증 불러오기")
                    //                                        .foregroundColor(.txt_color)
                    //                                }
                    //
                    //                                else{
                    //                                    VStack(alignment : .leading){
                    //                                        Text("학생증 로드 완료")
                    //                                            .foregroundColor(.white)
                    //
                    //                                        Text("다시 로드하려면 터치하세요")
                    //                                            .font(.caption)
                    //                                            .foregroundColor(.white)
                    //                                    }
                    //                                }
                    //
                    //                                Spacer()
                    //                            }
                    //                        }
                    //                        .padding(20)
                    //                        .padding([.horizontal], 20)
                    //                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(self.pickedImage == nil ? .btn_color : .accent).shadow(radius: 5)
                    //                                        .padding([.horizontal],15))
                    //                    }.isHidden(!showIDCard)
                    //                    .transition(AnyTransition.opacity.animation(.easeInOut))
                    
                    Group{
                        Divider()
                        
                        HStack {
                            Text("이용 약관을 읽어주세요.")
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                        }.padding(10)
                        
                        HStack{
                            CheckBox(checked: $acceptLicense)
                            
                            Text("서비스 이용약관 (필수)")
                                .onTapGesture(perform: {
                                    if acceptLicense{
                                        acceptLicense = false
                                    }
                                    
                                    else{
                                        self.acceptLicense = true
                                    }
                                })
                            
                            Spacer()
                            
                            Button(action: {
                                self.licenseType = .EULA
                                self.showLicense = true
                            }){
                                Text("읽기")
                            }.sheet(isPresented: $showLicense, content: {
                                EmptyView()
                            })
                            
                        }.padding(10)
                        
                        HStack{
                            CheckBox(checked: $acceptPrivacy)
                            
                            Text("개인정보 수집 및 이용방침 (필수)")
                                .onTapGesture(perform: {
                                    if acceptPrivacy{
                                        acceptPrivacy = false
                                    }
                                    
                                    else{
                                        self.acceptPrivacy = true
                                    }
                                })
                            
                            Spacer()
                            
                            Button(action: {
                                self.licenseType = .privacy
                                self.showLicense = true
                            }){
                                Text("읽기")
                            }.sheet(isPresented: $showLicense, content: {
                                EmptyView()
                            })
                            
                        }.padding(10)
                        
                        Divider()
                        
                        HStack{
                            CheckBox(checked: $acceptMarketing)
                            
                            Text("마케팅 정보 및 알림 수신 (선택)")
                                .onTapGesture(perform: {
                                    if acceptMarketing{
                                        self.acceptMarketing = false
                                    }
                                    
                                    else{
                                        self.acceptMarketing = true
                                    }
                                })
                            
                            Spacer()
                            
                            Button(action: {
                                self.licenseType = .marketing
                                self.showLicense = true
                            }){
                                Text("읽기")
                            }.sheet(isPresented: $showLicense, content: {
                                EmptyView()
                            })
                            
                        }.padding(10)
                        
                        Spacer().frame(height : 45)
                        
                        Button(action: {
                            if (self.name.isEmpty || self.phone.isEmpty || self.nickName.isEmpty || !self.acceptLicense || !self.acceptPrivacy){
                                self.showAlert = true
                            }
                            
                            else{
                                self.showProcess = true
                            }
                        }){
                            HStack{
                                Text("다음 단계로")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                                .padding([.horizontal], 100)
                                .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5).foregroundColor(.accent))
                                .disabled(self.name.isEmpty || self.studentNo.isEmpty || self.phone.isEmpty || self.nickName.isEmpty || self.pickedImage == nil || !self.acceptLicense || !self.acceptPrivacy)
                        }
                    }.isHidden(!showEULAArea)
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                    
                    Spacer()
                }
            }
        }
        
        .navigationBarTitle("회원가입", displayMode: .inline)
        
        .onAppear(perform: {
            changeText(text: "반가워요!")
        })
        
        .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        
        .sheet(isPresented: $showPicker, content: {
            ImagePickerView(sourceType: pickerType){(image) in
                self.pickedImage = Image(uiImage: image)
            }
        })
        
        .alert(isPresented : $showAlert){
            return Alert(title : Text("공백 필드"),
                         message: Text("모든 요구사항을 충족시켜주세요."),
                         dismissButton : .default(Text("확인")))
        }
        
        //        .disabled(self.name.isEmpty || self.studentNo.isEmpty || self.phone.isEmpty || self.nickName.isEmpty || self.pickedImage == nil || !self.acceptLicense || !self.acceptPrivacy)
        
        .sheet(isPresented: $showTutorial, content: {
            Tutorial_Main()
        })
        
        .fullScreenCover(isPresented: $showProcess, content: {
            signUp_register(name : $name, nickName: $nickName, studentNo : $studentNo, phone : $phone, marketingAccept: $acceptMarketing)
            
        })
        
        .accentColor(.accent)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
