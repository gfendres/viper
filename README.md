# VIPER

It does not matter what name you are going to use, VIPER, RIBs, Clean Swift. The idea behind all of the ideas is to follow Clean Architecture and making the life of the developers better :D.

VIPER is followed by: 

## V: View

- Dumb and passive.
- Communicate the events to the Presenter
- Never ask for data
- Deal with animation
- Deal with UI only
- Access only ViewModels with the needed data already formatted

## I: Interactor

- Business logic
- Has Services to perform requests
- Communicate back to Presenter via delegate

## P: Presenter

- Receives the View events
- Convert Models to ViewModels
- Interact with Interactor
- Interact with Router
- Is the center of the Module

## E: Entity (Models)

## R: Router

- Navigate to other Modules

# We also have:

## C: Contract

- Protocols

## B: Builder

- Create the Module

----

All the files and structure is called a `Module` which will be one per `screen/ ViewController / View`. We never use the same component (`Interactor`, `Presenter` ...) in a different `Module`.

If there is something that needs to be shared between `Modules`, it should be in a `Protocol` extension or `Class`, such as `Services`.

The `Modules` not necessary needs all the components. Maybe the `View` does not require any request for data, so the Interactor is not needed, but every `View` needs at least a `Presenter`.

## View

One important thing about the `View` is that it needs to be passive and never ask for something like `presenter.tracks()`.
The communication should always be passive, using the `Presenter` as an event handler. Some *Clean Architectures* have a `"Presenter"` with the name of `EventHandler`. We decided to keep `Presenter` to simplify and be easier to understand and avoid over-engineering by having both.

[View Code]

## Presenter

The `Presenter` is the centralized part of the VIPER architecture. It will receive the UI events and redirect it to `Interactor` or `Router` and implement the `Interactor` delegate converting `Models` to `ViewModel` presenting the data to the `View`.
Most of the `Presenter` public methods are `View` events, with that said testing the `Presenter` is almost like a UI test and so much faster and less prone to flakiness than `XCUI`.

[Presenter Code]

## Interactor

`Interactor` will have most of the business logic and handle the retrieving data from `Services`. The `Interactor` is usually initialized with a `Service` `Protocol` to do request and handle data. 

[Interactor Code]

## Router

The `Router` is responsible for redirecting to new `Modules` using their `Builders`. Usually, It has a weak reference to the `View Controller` to be able to push to a new `Module`.

[Router Code]

## Contract

The `Contract` is a file which will have the `Protocols` which each part will communicate with each other. All the communication is based on `Protocols`, following the `Protocol Oriented Programming`. 
The exciting part of the `Contract` is that you have all the `Protocols` here, having a big picture of how it behaves. 
It is the first file to code, defining what the components will implement and how the will be related. 

[Contract Code]

## Builder

Creates the `Module` injecting the dependencies and returns the `View`.
It usually has only one method to assemble the entire `Module`.

[Builder Code]
