import SwiftUI
import GoogleSignIn
import AuthenticationServices

struct LoginView: View {
    @State var emailText: String = ""
    @State var passwordText: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack {
                Text("Book Billionare")
                    .font(.title)
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
                            .foregroundStyle(Color.accentColor)
                    }
                    Button{
                        authViewModel.emailAuthLogIn(email: emailText, password: passwordText)
                        dismiss()
                    } label: {
                        Text("로그인")
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.accentColor)
                            .background(emailText.isEmpty || passwordText.isEmpty ? .gray : .red)
                            .cornerRadius(10)
                    }
                    .disabled(emailText.isEmpty || passwordText.isEmpty ? true : false)
                }
                
                Text("다른 방법으로 로그인")
                    .padding()
                
                Button {
                    // 구글 로그인 버튼 눌렀을 때의 동작
                } label: {
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
        }

    }
}

#Preview {
    LoginView()
}
