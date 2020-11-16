//
//  MockSweetService.swift
//  DebuggingApp
//
//  Created by Teacher on 01.11.2020.
//

import Foundation

class MockSweetService: SweetService {
    private lazy var sweets: [Sweet] = mockSweets()

    func loadFeed(
        after lastSweetId: UUID?,
        completion: @escaping (Result<[Sweet], SweetServiceError>) -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if let lastSweetId = lastSweetId {
                guard let lastSweetIndex = self.sweets.firstIndex(where: { $0.id == lastSweetId }) else {
                    return completion(.failure(.notFound))
                }

                completion(
                    .success(
                        Array(
                            self.sweets
                                .dropFirst(lastSweetIndex + 1)
                                .prefix(5)
                        )
                    )
                )
            } else {
                completion(.success(Array(self.sweets.prefix(20))))
            }
        }
    }

    func postSweet(
        withTitle title: String?,
        text: String,
        completion: @escaping (Result<Sweet, SweetServiceError>) -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let sweet = Sweet(id: UUID(), date: Date(), author: "Me", title: title, text: text)
            self.sweets.insert(sweet, at: 0)
            completion(.success(sweet))
        }
    }

    private func mockSweets() -> [Sweet] {
        var intervalOffset: TimeInterval = 0
        func newInterval() -> TimeInterval {
            intervalOffset -= TimeInterval.random(in: 1...(60 * 60 * 24))
            return intervalOffset
        }
        let currentDate = Date()

        return (1...123)
            .map { _ in
                Sweet(
                    id: UUID(),
                    date: Date(timeInterval: newInterval(), since: currentDate),
                    author: randomAuthor(),
                    title: randomTitle(),
                    text: randomText()
                )
            }
    }

    private func randomAuthor() -> String {
        [
            "Абигейл", "Ава", "Азалия", "Александр", "Александра", "Алексей", "Алиса", "Альфия", "Амелия", "Амина", "Амир", "Анастасия",
            "Андрей", "Анна", "Арина", "Арсений", "Артем", "Артур", "Асия", "Валерия", "Варвара", "Вероника", "Виктор", "Виктория",
            "Вильям", "Грейс", "Гульназ", "Дамир", "Даниил", "Данил", "Дарина", "Дарья", "Джейдан", "Джейкоб", "Джексон", "Диего", "Дилан",
            "Дмитрий", "Дэвид", "Дэниел", "Ева", "Егор", "Екатерина", "Елизавета", "Зарина", "Изабелла", "Илья", "Итан", "Камиль", "Карим",
            "Кира", "Кирилл", "Лиам", "Луис", "Майкл", "Максим", "Марат", "Маргарита", "Мария", "Мариям", "Марк", "Медисон", "Милана",
            "Михаил", "Мия", "Натали", "Нои", "Оливия", "Пенелопа", "Полина", "Радмир", "Ралина", "Регина", "Ренат", "Роман", "Рустам",
            "Самир", "Самира", "Себастьян", "София", "Степан", "Таисия", "Тимофей", "Тимур", "Ульяна", "Харпер", "Хлоя", "Шарлотта",
            "Эвелин", "Эвери", "Эдриан", "Элизабет", "Элия", "Элла", "Эльвира", "Эмили", "Эмма", "Ярослав", "Ясмина"
        ].randomElement()!
    }

    private func randomTitle() -> String? {
        switch Int.random(in: 1...5) {
            case 1:
                return "Забавно:"
            case 2:
                return "А как вы думаете?"
            case 3:
                return "Я всегда повторяю себе эту мантру..."
            case 4:
                return "Только ситхи всё возводят в абсолют!"
            default:
                return nil
        }
    }

    private func randomText() -> String {
        switch Int.random(in: 1...5) {
            case 1:
                return """
                    Did you ever hear the Tragedy of Darth Plagueis the wise?
                    """
            case 2:
                return """
                    I thought not. It's not a story the Jedi would tell you. It's a Sith legend.
                    """
            case 3:
                return """
                    Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the \
                    midichlorians to create life... He had such a knowledge of the dark side that he could even keep the ones he cared \
                    about from dying. The dark side of the Force is a pathway to many abilities some consider to be unnatural.
                    """
            case 4:
                return """
                    He became so powerful... the only thing he was afraid of was losing his power, which eventually, of course, he did. \
                    Unfortunately, he taught his apprentice everything he knew, then his apprentice killed him in his sleep. It's ironic \
                    he could save others from death, but not himself.
                    """
            case 5:
                return """
                    Did you ever hear the Tragedy of Darth Plagueis the wise? I thought not. It's not a story the Jedi would tell you. \
                    It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to \
                    influence the midichlorians to create life... He had such a knowledge of the dark side that he could even keep the \
                    ones he cared about from dying. The dark side of the Force is a pathway to many abilities some consider to be \
                    unnatural. He became so powerful... the only thing he was afraid of was losing his power, which eventually, of course, \
                    he did. Unfortunately, he taught his apprentice everything he knew, then his apprentice killed him in his sleep. It's \
                    ironic he could save others from death, but not himself.
                    """
            default:
                return ""
        }
    }
}
