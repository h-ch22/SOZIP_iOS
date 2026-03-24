![ ](README/mockup.png)<br>
<img src="./README/appstore.png" width=200>

소집 : SOZIP
=====
> An application for Delivery Cost Dutch Pay<br>

###### '소집(SOZIP) means to gather (people, etc.) in Korean.'

ⓒ 2021 Changjin Ha, Sojung Moon. All rights reserved.

## 🚀 Tech Stack

### Client (iOS)

<img src="https://img.shields.io/badge/Swift-df5d43?style=flat-square&logo=Swift&logoColor=white"/></a>
<img src="https://img.shields.io/badge/SwiftUI-df5d43?style=flat-square&logo=Swift&logoColor=white"/></a>
<img src="https://img.shields.io/badge/iOS%20UIKit-147EFB?style=flat-square&logo=Xcode&logoColor=white"/></a>

### Backend (BaaS & Serverless)

- Firebase Firestore: Realtime chat and sync SOZIP data
- Firebase Cloud Functions: Process backend business logic for reduce client burden
- Firebase Cloud Messaging: Send push notifications to target user when created new SOZIP and chat

### External API

- Naver Maps API (Render location based markers)


## 🏗️ Architecture

graph TD
    %% Client
    subgraph Client [📱 iOS App]
        UI[UIKit / SwiftUI]
        State[State Management]
    end

    %% Backend & Infra
    subgraph Serverless [☁️ Firebase BaaS]
        Auth[Firebase Auth]
        DB[Firebase Firestore]
        Storage[Firebase Storage]
        Funcions[Firebase Cloud Functions]
        FCM[Firebase Cloud Messaging]
    end

    %% External API
    subgraph External [External APIs]
        Map[Naver Maps API]
    end

    %% Data flow
    UI <--> State
    State <--> Auth
    State <--> DB
    State <--> Storage
    State --> Map

    %% Push notifications and BE logic flow
    DB -->|Event Trigger| Functions
    Functions -->|Send Push Request| FCM
    FCM -.->|Push Notification| UI

## 🧱 If I were to rebuild it in 2026

| Layer | Original | 2026 Pick | Reason |
|---|---|---|---|
| UI | Swift UI + UIKit App Delegate | SwiftUI + `@main App` struct only | AppDelegate is only needed for Firebase setup; `FirebaseApp.configure()` can move to the `App` initializer |
| State Management | `ObservableObject` + `@ObservedObject` passed via init | `@Observable` macro (Swift 5.9) + `@Environment` | Less boilerplate, no need to pass helpers through every init |
| Async | Completion handlers | `async/await` + `AsyncStream` for Firebase listener | Linear, readable, type safe |
| Image loading | SDWebImage + SDWebImageSwiftUI | `AsyncImage` | Remove 2 deps |
| JSON parsing | SwiftyJSON | `Codable` | No extra dep, first-party |
| Credentials storage | UserDefaults (encrypted) | Firebase Auth session persistence only | Don't store credentials at all |
| Auth state observation | Manual callbacks | `Auth.auth().authStateDidChangePublisher()` or `Asyncstream` | Reactive, no polling |
| Firebase SDK | Pinned to `master` branch | Pinned to release tag | Build stability |
| Error handling | `String?` completion codes (`"success"`, `"error"`) | `Result<T, AppError>` or `throws` | Type-safe, exhaustive |
| Testing | None | XCTest unit tests for Helper layer + Swift Testing framework | Required for financial logic |

## ✨ Core Features<br>
<details>
<summary>Show Contents</summary>

#### Home<br>
> Check any SOZIPs near by you, or notifications <br>

![ ](README/0.jpeg)<br>

#### SOZIP Map<br>
> Check and contact to all SOZIPs <br>

![ ](README/06.jpeg)<br>

#### SOZIP<br>
> Check location, participants, or manage your SOZIP in SOZIP Details<br>

![ ](README/2.jpeg)<br>
![ ](README/10.jpeg)<br>

> Don't you have a favorite SOZIP? Feel free to make it!<br>

![ ](README/1.jpeg)
![ ](README/3.jpeg)<br>

#### Chat<br>
> Feel free to talk to the participants <br>

![ ](README/13.jpeg)<br>

> Or you can send any images, bank accounts, or manage your SOZIP. it's so easy. <br>

![ ](README/8.jpeg)
![ ](README/5.jpeg)<br>


#### Profile<br>
> Show others your unique personality in your profile <br>

![ ](README/12.jpeg)<br>

#### Consulting<br>
> Are you experiencing any problems using SOZIP? Feel free to contact us! <br>

![ ](README/Consulting_1.png)
![ ](README/Consulting_2.png)
![ ](README/Consulting_3.png)<br>

#### Feedback Hub<br>
> Improve 소집 : SOZIP with your opinion. <br>

![ ](README/FeedbackHub.png)<br>

</details>
