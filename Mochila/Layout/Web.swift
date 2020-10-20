//
//  Web.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import WebKit

extension WKWebsiteDataStore {
    
    public func cookie(_ domain: String? = nil, completion:@escaping ([HTTPCookie]) -> Void) {
        guard let domain = domain else {
            httpCookieStore.getAllCookies(completion)
            return
        }

        httpCookieStore.getAllCookies { cookies in
            let filteredCookies = cookies.filter { ($0.domain as NSString).range(of: domain).location != NSNotFound }
            completion(filteredCookies)
        }
    }

    public func deleteCookie(_ cookie: HTTPCookie, completion:(() -> Void)? = nil) {
        httpCookieStore.delete(cookie, completionHandler: completion)
    }
}

extension WKWebView {
    public func syncCookies(_ domain: String? = nil, completion:@escaping () -> Void) {
        guard let cookies = HTTPCookieStorage.cookies(domain) else { return }

        let group = DispatchGroup()
        for cookie in cookies {
            group.enter()
            configuration.websiteDataStore.httpCookieStore.setCookie(cookie) {
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            completion()
        }
    }

    public func deleteAllCookies(completion:@escaping () -> Void) {
        configuration.websiteDataStore.cookie { cookies in
            let group = DispatchGroup()
            for cookie in cookies {
                group.enter()
                self.configuration.websiteDataStore.deleteCookie(cookie) {
                    group.leave()
                }
            }
            group.notify(queue: DispatchQueue.main) {
                completion()
            }
        }
    }
}
