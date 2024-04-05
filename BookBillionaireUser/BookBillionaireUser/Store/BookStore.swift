//
//  BookStore.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/3/24.
//

import Foundation
import BookBillionaireCore

struct BookStore {
    var books: [Book] = []
    
    init() {
        books = [
//            Book(owenerID: UUID().uuidString, title: "testForNill", contents: "description", authors: ["UDI"], thumbnail: "" , rental: UUID().uuidString),
            
            Book(owenerID: UUID().uuidString, isbn: "8955617089 9788955617085", title: "침팬지 폴리틱스(리커버:K)", contents: "정치의 기원은 인류의 역사보다 오래되었다.    초판 출간 후 수십 년간 세계적인 베스트셀러의 자리를 지키며 이제는 과학저술의 고전으로 우뚝 선 《침팬지 폴리틱스》의 25주년 기념판.  세계적인 영장류학자 프란스 드 발의 《침팬지 폴리틱스》는 출간 즉시 영장류학자들로부터 그 과학적 성과를 인정받아 베스트셀러가 되었을 뿐만 아니라, 정치가, 기업경영인, 사회심리학자들로부터 인간의 가장 근본적인 본성에 대한 놀라운 통찰을 준다는 찬사를 받았다.  정치는", publisher: "바다출판사", authors: ["프란스 드 발"], translators: ["장대익"], price: 18000, thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F716021%3Ftimestamp%3D20240402115407", bookCategory: .none, rental: UUID().uuidString),
            
            Book(owenerID: UUID().uuidString, isbn: "1191826376 9791191826371", title: "밤티 마을 마리네 집", contents: "마을 큰돌이네 집』 출간을 시작으로 오랜 시간 스테디셀러 자리를 굳건히 지키고 있는 연작 동화 세 권은, 독자들이 끊임없이 후속작 요청을 했기에 이루어진 결실이다. 그래서 『밤티 마을 큰돌이네 집』에 이어 『밤티 마을 영미네 집』과 『밤티 마을 봄이네 집』을 출간할 수 있었고, 지금까지도 독자들의 아낌없는 지지와 사랑을 받고 있다. 이금이 작가의 ‘밤티 마을 이야기’가 한국 아동문학사에서 갖는 의미는 매우 크다. 2024년 한국 최초로 한스 크리스티안 안데르센상", publisher: "밤티", authors: ["이금이"], translators: [], price: 13500, thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6589380%3Ftimestamp%3D20240402174057", bookCategory: .none, rental: UUID().uuidString),
            
            Book(owenerID: UUID().uuidString, isbn: "8954698727 9788954698726", title: "패밀리 레스토랑 가자(상)", contents: "신드롬을 일으킨 『가라오케 가자!』. 출간 직후 종합 베스트셀러 1위는 물론, 탄탄한 팬덤이 생길 만큼 화제가 되었던 작품이다. 끔찍한 벌칙이 걸린 가라오케 대회를 위해 의기투합했던 야쿠자 쿄지와 독설 노래 선생 사토미의 뒷이야기를 궁금해하고, 오매불망 기다려왔던 독자들에게 새로운 이야기가 도착했다.  대학생이 된 사토미는 상경 후 홀로 자취를 시작한다. 그런데 이 어린 청년, 근검절약이 심상치 않다. 우연한 계기로 심야의 패밀리 레스토랑 아르바이트를 시작한", publisher: "문학동네", authors: ["와야마 야마"], translators: ["현승희"], price: 8500, thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6598321%3Ftimestamp%3D20240402174317", bookCategory: .none, rental: UUID().uuidString),
            
            Book(owenerID: UUID().uuidString, isbn: "1169811914 9791169811910", title: "풀벌레그림꿈", contents: "이야기를 풀어놓습니다. 작은 풀벌레가 차 한 잔 드는 간소한 그림 한 점에도 시선이 오래 머무릅니다. 순도 높은 무해한 풀벌레의 세계에서 떠나고 싶지 않은, 이상한 평화의 기운을 전하는 그림책입니다.  아주아주 작은 풀벌레가 매일 사람이 되는 꿈을 꿉니다  이 그림책은 누드사철제본으로, 일반적인 책등을 빼고 풀빛 색실만 보이게끔 연출한 작은 책입니다. 단단한 표지의 가운데 3cm 가량의 동그란 구멍이 있습니다. 구멍을 들여다보면, 이제 막 차를 마시려고 차", publisher: "사계절", authors: [], translators: [], price: 18000, thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6596606%3Ftimestamp%3D20240402174246", bookCategory: .none, rental: UUID().uuidString),
            
            Book(owenerID: UUID().uuidString, isbn: "1169850715 9791169850711", title: "민주주의적 자본주의의 위기", contents: "감화된다. 이 책의 저자 마틴 울프는 경제에 대한 실망이 고소득 민주주의 국가에서 좌우를 막론하고 포퓰리즘이 득세하는 원인이 된다고 지적했다. 세계적인 경제평론가인 마틴 울프는 2016년 트럼프 대통령의 탄생을 지켜보며 『민주주의적 자본주의의 위기』의 집필을 결심했다고 밝힌 바 있으며, 트럼프의 대선 후보 복귀가 점쳐지기 시작했던 2023년 3월에 이 책의 원서(『THE CRISIS OF DEMOCRATIC CAPITALISM』)를 출간했다. 그는 자본주의 체제", publisher: "페이지2북스", authors: ["마틴 울프"], translators: ["고한석"], price: 38000, thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6595065%3Ftimestamp%3D20240402174146", bookCategory: .none, rental: UUID().uuidString),
            
            Book(owenerID: UUID().uuidString, isbn: "1647221552 9781647221553", title: "The Art and Soul of Dune", contents: "Blade Runner 2049, Arrival). Now fans can be part of the creative journey of bringing Herbert\'s seminal work to life with The Art and Making of Dune, the only official companion to the hugely anticipated movie event.  This comprehensive and detailed exploration of", publisher: "Insight Editions", authors: ["Insight Editions", "Villeneuve Denis", "Lapointe Tanya"], translators: [], price: 60000, thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F5873061%3Ftimestamp%3D20231114182403", bookCategory: .none, rental: UUID().uuidString),
            
            Book(owenerID: UUID().uuidString, isbn: "1170522696 9791170522690", title: "가여운 것들", contents: "스코틀랜드를 대표하는 작가 앨러스데어 그레이의 장편소설 『가여운 것들』이 황금가지에서 출간되었다. 20여 년의 집필 끝에 완성된 첫 출간작 『라나크』로 단테, 조이스, 오웰, 카프카 같은 문학계 거장들에 비견되며 스코틀랜드 문학을 논할 때 빼놓을 수 없는 작가의 반열에 오른 그레이의 또 다른 대표작으로, 언론과 평단의 찬사를 얻으며 휘트브레드상과 가디언 픽션상을 수상하였고 그의 작품 중에서 가장 상업적으로 성공한 것으로도 알려져 있다. 어느 빅토리아", publisher: "황금가지", authors: ["앨러스데어 그레이"], translators: ["이운경"], price: 18000, thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6339295%3Ftimestamp%3D20240401161924", bookCategory: .none, rental: UUID().uuidString),
            
            Book(owenerID: UUID().uuidString, isbn: " 9791169765114", title: "흑마법사는 야근을 한다. 1", contents: "엘프와 안드로이드, 마법과 인터넷이 공존하는 시대. 검은 도시의 뒷골목을 지배하는 이는, 그저 한 명의 회사원이었다.", publisher: "에이시스미디어", authors: ["까만밤섬"], translators: [], price: 0, thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6550227", bookCategory: .none, rental: UUID().uuidString),

            Book(owenerID: UUID().uuidString, isbn: " 9791138034180", title: "천의지로. 1", contents: "명 황제의 황명으로 천하 백대 문파의 비급이 한 자리에 모이게 된다.  그 무서들을 모두 읽은 한 무인의 이야기.", publisher: "영상출판미디어(영상노트)", authors: ["맹아"], translators: [], price: 0, thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6504973", bookCategory: .none, rental: UUID().uuidString),

            Book(owenerID: UUID().uuidString, isbn: "117213037X 9791172130374", title: "원도", contents: "증명》에서부터 소설적 성취의 완결을 보여준《단 한 사람》까지, 발표하는 소설마다 특유의 거침없는 서사와 긴 여운을 남기는 서정으로 최진영 유니버스는 바야흐로 점점 더 확장 중이다. 그렇다면 최진영 유니버스의 시작은 어디서부터였을까? 《원도》가 그 실마리가 되어줄 것이다. 2013년 ‘나는 왜 죽지 않았는가’라는 제목으로 출간되어 짧게 독자를 만나고 절판된 채 중고책 시장에서 수만 원을 호가하며 판매되는 등 내내 복간 요청이 끊이지 않았던 이 장편소설이", publisher: "한겨레출판사", authors: ["최진영"], translators: [], price: 15000, thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6591317%3Ftimestamp%3D20240401161945", bookCategory: .none, rental: UUID().uuidString)
            ]
    }
}
