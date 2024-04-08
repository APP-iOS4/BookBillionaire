import SwiftUI
import GoogleSignIn
import AuthenticationServices

struct LoginView: View {
    @State var emailText: String = ""
    @State var passwordText: String = ""
    @State var signInProcessing: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Color.accentColor1
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("logo")
                    .frame(width: 100, height: 100)
                    .padding(.top, 50)
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .cornerRadius(10)
                        .frame(width: 335, height: 250)
                    VStack(spacing: 10) {
                        TextField("email", text: $emailText)
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .textInputAutocapitalization(.never)
                        SecureField("Password", text: $passwordText)
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .textInputAutocapitalization(.never)
                        
                        HStack {
                            Spacer()
                            NavigationLink {
                                SignUpView()
                            } label: {
                                HStack {
                                    Text("회원가입")
                                        .foregroundColor(.accentColor1)
                                }
                            }
                            Spacer()
                            Button(action: {
                                signInProcessing = true
                                authViewModel.emailAuthLogIn(email: emailText, password: passwordText)
                            }) {
                                ZStack {
                                    Text("로그인")
                                        .padding()
                                        .background(Color.white)
                                        .foregroundColor(.accentColor1)
                                        .background(emailText.isEmpty || passwordText.isEmpty ? .gray : .red)
                                        .cornerRadius(10)
                                    
                                    if signInProcessing {
                                        ProgressView()
                                    }
                                }
                            }
                            .disabled(emailText.isEmpty || passwordText.isEmpty ? true : false)
                            Spacer()
                        }
                        .padding(.top, 20)
                    }
                }
                .padding(.horizontal, 50)
                
                Text("Or")
                    .foregroundColor(.white)
                    .padding()
                
                Button(action: {
                    // 구글 로그인 버튼 눌렀을 때의 동작
                    
                }) {
                    Image("SignInWithGoogle")
                        .resizable()
                        .frame(width: 335, height: 50)
                }
                .padding(.bottom, 10)
                Spacer()
            }
        }
        
    }
}

#Preview {
    LoginView()
}
