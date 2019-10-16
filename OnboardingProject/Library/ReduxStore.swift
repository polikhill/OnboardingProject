//
//  ReduxStore.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/10/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ReduxStore<State, Action> {
    
    typealias Reducer = (State, Action) -> State
    typealias Dispatch = (Action) -> Void
    typealias StateProvider = () -> State
    typealias Middleware = (@escaping Dispatch, @escaping () -> State) -> (@escaping Dispatch) -> Dispatch
    
    private let reducer: Reducer
    
    let state: Observable<State>
    private let stateVariable: BehaviorRelay<State>
    private var dispatchFunction: Dispatch!
    
    init(
        initialState: State,
        reducer: @escaping Reducer,
        middlewares: [Middleware]
        ) {
        let stateVariable = BehaviorRelay(value: initialState)
        
        self.reducer = reducer
        self.state = stateVariable.asObservable()
        
        let defaultDispatch: Dispatch = { action in
            stateVariable.accept(reducer(stateVariable.value, action))
        }
        
        self.stateVariable = stateVariable
        self.dispatchFunction = middlewares
            .reversed()
            .reduce(defaultDispatch) { (dispatchFunction, middleware) -> Dispatch in
                let dispatch: Dispatch = { [weak self] in self?.dispatch(action: $0) }
                let getState: StateProvider = { stateVariable.value }
                return middleware(dispatch, getState)(dispatchFunction)
        }
    }
    
    func dispatch(action: Action) {
        dispatchFunction?(action)
    }
    
    func getState() -> State {
        return stateVariable.value
    }
    
    static func makeMiddleware(worker: @escaping (@escaping Dispatch, StateProvider, Dispatch, Action) -> Void) -> Middleware {
        return { dispatch, getState in { next in { action in worker(dispatch, getState, next, action) } } }
    }
}
