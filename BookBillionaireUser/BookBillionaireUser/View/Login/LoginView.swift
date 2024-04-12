import SwiftUI
import GoogleSignIn
import AuthenticationServices

struct LoginView: View {
    @State var emailText: String = ""
    @State var passwordText: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isSignUpScreen: Bool = false
    @EnvironmentObject var authViewModelGoogle: AuthViewModelGoogle
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack {
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
                    Button("회원가입") {
                        isSignUpScreen = true
                    }
                    .buttonStyle(WhiteButtonStyle(height: 40.0))

                    Button{
                        authViewModel.signIn(email: emailText, password: passwordText)
                        dismiss()
                    }.buttonStyle(WhiteButtonStyle(height: 40.0))
                        .foregroundStyle(emailText.isEmpty || passwordText.isEmpty ? .gray : .accentColor)
                        .disabled(emailText.isEmpty || passwordText.isEmpty ? true : false)
                }
                .padding(.top)
                
                Text("다른 방법으로 로그인")
                    .padding()
                
                Button(action: {
                    authViewModelGoogle.signIn(email: "", password: "")
                    dismiss()
                }) {
                    Image("SignInWithGoogle")
                        .resizable()
                        .frame(width: 335, height: 50)
                }
                .padding(.bottom, 10)
                Spacer()
                Spacer()
                Text("Team BB")
                SpaceBox()
            }
            .padding(.horizontal, 30)
            .fullScreenCover(isPresented: $isSignUpScreen, content: {
                SignUpView()
            })
        }

    }
}

#Preview {
    LoginView()
}
