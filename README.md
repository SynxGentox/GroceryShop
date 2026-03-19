# Grocery Store

A SwiftUI grocery shopping app with 
category filtering and cart management.

## Features
- Browse items in a responsive grid layout
- Filter by category — Fruits, Veggies, Dairy
- Animated filter expand/collapse
- Cart with quantity tracking
- Dark and light mode support

## In Progress
- Cart screen with quantity controls
- Item detail screen
- Category filtering functionality
- Purchase flow

## Architecture
- @Observable / MVVM
- Single source of truth via GroceryStore
- Dictionary-based cart (UUID → quantity)
- Computed category filters

## Tech
- SwiftUI
- @Observable
- NavigationStack
- LazyVGrid
- GlassEffect
