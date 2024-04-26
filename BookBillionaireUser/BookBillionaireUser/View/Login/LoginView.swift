import SwiftUI
import GoogleSignIn
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var authViewModelGoogle: AuthViewModelGoogle
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) private var dismiss

    @Binding var isPresentedLogin: Bool
#if DEBUG
    @State var emailText: String = "2@gmail.com"
    @State var passwordText: String = "12341234"
    #else
    @State var emailText: String = ""
    @State var passwordText: String = ""
    #endif
    
    @State private var isSignUpScreen: Bool = false
    var PrivatePolicyUrl = Bundle.main.url(forResource: "PrivatePolicy", withExtension: "html")!
    @State private var isPrivateSheet: Bool = false


    var body: some View {
        NavigationView {
            VStack {
                HStack() {
                    Spacer()
                    Button(action: {
                        isPresentedLogin.toggle()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                }
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 100)

                Section {
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
                    }
                }
                .padding(.top, 50)

                HStack(spacing: 20) {
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("회원가입")
                    }.buttonStyle(WhiteButtonStyle(height: 40.0))
                    
                    Button("로그인") {
                        authViewModel.signIn(email: emailText, password: passwordText)
                        dismiss()
                    }
                    .buttonStyle(WhiteButtonStyle(height: 40.0))
                    .foregroundStyle(emailText.isEmpty || passwordText.isEmpty ? .gray : .accentColor)
                    .disabled(emailText.isEmpty || passwordText.isEmpty ? true : false)
                }
                .padding(.top)

                Text("다른 방법으로 로그인")
                    .padding()

                Button(action: {
                    authViewModelGoogle.signIn(email: nil, password: nil)
                    dismiss()
                }) {
                    Image("SignInWithGoogle")
                        .scaledToFit()
                }
                .padding(.bottom, 10)
                
                AppleSigninButton()
                
                Spacer()
                Spacer()
                HStack{
                    Text("가입 시,")
                        Text("개인정보 처리방침")
                            .underline()
                            .onTapGesture {
                                isPrivateSheet = true
                            }
                        Text("에 동의하게 됩니다.")
                }
                .font(.caption)
                SpaceBox()
            }
            .padding(.horizontal, 30)
            .navigationBarHidden(true)
            .sheet(isPresented: $isPrivateSheet, content: {
                WebView(url: PrivatePolicyUrl)
                    .padding(30)
            })
            // Hide navigation bar
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isPresentedLogin: .constant(true))
    }
}
