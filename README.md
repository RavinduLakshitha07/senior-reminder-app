# senior_reminder_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 2026/07/18

Brick 1 ✅

Flutter Project
Theme
Home Screen

-----------------------

Brick 2

Reminder Model
Hive Storage
Provider

(No build_runner)

-----------------------

Brick 3

Beautiful Home Screen

-----------------------

Brick 4

Add Reminder Screen

-----------------------

Brick 5

Notifications

-----------------------

Brick 6

Alarm Sounds

-----------------------

Brick 7

Full Screen Popup


19/07/2026
 ReminderProvider
    │
    ├── Creates Reminder
    ├── Calculates next reminder date
    └── Calls NotificationService

NotificationService
    │
    ├── Schedule notification
    ├── Cancel notification
    └── Initialize notifications




    Design a mobile alarm screen for a "Senior Reminder" app targeting older adults (60+).

Screen size: 390 × 844px (iPhone 15 Pro)

Design style:
- Clean, minimal, calming
- Soft pastel gradient background (light green to light blue)
- Large readable elements
- Apple Health / Material 3 inspired

Colors:
- Background: linear-gradient from #E8F5E9 to #E3F2FD
- Primary green: #2E7D32
- Orange (snooze): #FB8C00
- Blue (snooze): #1976D2
- Text: #212121
- Subtext: #757575

Layout (top to bottom):

1. STATUS BAR
   - Time "9:41" on left
   - Battery/signal on right
   - Font size 15px, bold

2. LARGE CLOCK
   - Display current time: "08:00"
   - Font size 72px, bold, letter-spacing -3px
   - Below it: day and date in 18px muted text
   - e.g., "Monday, January 21"

3. ANIMATED BELL ICON (center)
   - Large circular button: 148 × 148px
   - Border radius: 52px
   - Background: #2E7D32 (emerald green)
   - Box shadow: 0 16px 52px rgba(46,125,50,0.35)
   - Bell icon: 70px, white, strokeWidth 2
   - Animation: ringing motion — rotate(-18deg to 18deg), 
     repeating every 1.2 seconds using spring/keyframe

4. REMINDER INFO (below bell)
   - Small label: "Time for your" — 18px, muted gray
   - Reminder title: "Morning Medication" — 30px, bold, dark
   - Category tag: "💊 Medication · Daily" — 15px, muted

5. THREE ACTION BUTTONS (bottom, stacked vertically)
   Each button: full width, height 64px, border-radius 20px,
   font-size 18px, bold, with left icon

   Button 1 — Snooze 5 Minutes
   - Background: #FFF3E0 (orange light)
   - Text color: #FB8C00
   - Icon: Clock (orange)

   Button 2 — Snooze 10 Minutes
   - Background: #E3F2FD (blue light)
   - Text color: #1976D2
   - Icon: Clock (blue)

   Button 3 — Stop Reminder
   - Background: #2E7D32 (solid green)
   - Text color: white
   - Icon: Check (white)

Typography: Inter / SF Pro style
Accessibility: all touch targets minimum 64px height, high contrast text
Animation library: motion/react (for bell ringing)
Framework: React + Tailwind CSS




🏅 Badge Unlock System
There are 13 badges across several categories:

Badge	Trigger
🎯 First Step	Complete 1 reminder
🔥 5-Day Streak	5 consecutive days
⭐ Perfect Week	7 consecutive days
💪 Monthly Master	30 consecutive days
💊 Med Master	Complete 30 medicine reminders
💧 Hydrated	Complete 20 water reminders
❤️ Health Hero	Complete 50 total reminders
🏅 Bronze Medal	Earn 100 XP
🥈 Silver Medal	Earn 500 XP
🥇 Gold Medal	Earn 1,000 XP
🌟 Perfect Day	Complete all reminders for a day
🚀 Level 5	Reach level 5
💎 Diamond	Reach level 10

2026/07/27
- [ ] 1. BMI calculate speed - reduce animation duration 800ms → 300ms
- [ ] 2. Save Reading → navigate to BMI reports
- [ ] 3. Toggle OFF → mark completed in history
- [ ] 4. Delete reminders from history
- [ ] 5. Achievements overflow fix
- [ ] 6. Fix Dark Mode
- [ ] 7. Fix Senior Mode  
- [ ] 8. Fix username issue

UI Polish

Act as a Senior Product Designer from Apple, Google Material Design, and Linear.

I already have a fully functional Flutter application called "Senior Reminder App". Do NOT change the app's features or user flow. Your task is ONLY to redesign the UI into a premium, modern healthcare application while maintaining excellent accessibility for elderly users.

The final result should look like a professionally designed healthcare app suitable for the Google Play Store and App Store.

──────────────────────────────
DESIGN STYLE
──────────────────────────────

Create a premium UI inspired by:

• AidleTech
• Linear
• Stripe
• Apple Health
• Google Material 3
• Vercel

The interface should feel:

• Elegant
• Modern
• Calm
• Trustworthy
• Minimal
• Spacious
• Premium
• Healthcare-focused

NOT playful.
NOT childish.
NOT overly colorful.

──────────────────────────────
KEEP THESE FEATURES
──────────────────────────────

Do NOT remove or change:

• Home Screen
• Reminder List
• History
• Statistics
• BMI Calculator
• Settings
• Add Reminder
• Notifications
• Voice Reminder
• Emergency Contact
• Dark Mode
• Senior Mode

Only improve the visual design.

──────────────────────────────
COLOR SYSTEM
──────────────────────────────

Background

#F8FAFC

Secondary Background

#EEF5FF

Primary Green

#2E7D32

Secondary Green

#66BB6A

Medical Blue

#2563EB

Amber

#F59E0B

Error

#EF4444

Card

#FFFFFF

Primary Text

#111827

Secondary Text

#6B7280

Use subtle gradients throughout the app.

──────────────────────────────
VISUAL STYLE
──────────────────────────────

Replace flat design with premium cards.

Use:

• Soft shadows
• Rounded corners (24-30px)
• Gradient buttons
• Soft glassmorphism only for important dashboard cards
• Beautiful spacing
• Elegant dividers
• Smooth animations
• Premium typography

Everything should feel light and luxurious.

──────────────────────────────
TYPOGRAPHY
──────────────────────────────

Screen Title

34sp
Bold

Section Title

26sp

Card Title

22sp

Body

18-20sp

Button

20sp

Never use fonts smaller than 18sp.

──────────────────────────────
HOME SCREEN
──────────────────────────────

Design an elegant dashboard.

Top section:

Greeting

Good Morning 👋

Welcome back,
Laka

Small motivational sentence

"You have 2 reminders today."

Today's Overview

Replace small statistic boxes with

Animated circular progress

Completion %

Today's reminders

Completed

Pending

Missed

Next Reminder Card

Large premium card

Category icon

Reminder title

Time

Remaining time

Status chip

Quick Action

Categories

Beautiful rounded cards

Premium icons

Medication

Doctor

Meal

Exercise

Health

Other

Upcoming Reminders

Timeline style

Large cards

Soft shadows

Status indicator

──────────────────────────────
BOTTOM NAVIGATION
──────────────────────────────

Completely redesign.

Floating navigation bar.

Rounded.

Glass blur.

Soft shadow.

Animated active indicator.

Premium Material 3 style.

Center Add button should float above navigation with gradient background.

──────────────────────────────
REMINDER CARDS
──────────────────────────────

Large rounded cards

Gradient accent strip

Premium icon

Reminder title

Time

Repeat schedule

Status badge

Chevron

Soft animation when tapped

Swipe animation

──────────────────────────────
ADD REMINDER PAGE
──────────────────────────────

Large elegant input fields

Rounded corners

Modern category cards

Animated selection

Beautiful date picker

Premium time picker

Gradient Save button

Large spacing

Easy to use for seniors

──────────────────────────────
SETTINGS
──────────────────────────────

Separate into beautiful cards.

Accessibility

Notifications

Appearance

Account

About

Each card should have:

Premium icon

Large title

Subtitle

Elegant switch

Soft divider

──────────────────────────────
BMI SCREEN
──────────────────────────────

Create premium medical dashboard.

Gradient Result Card

Animated BMI Meter

Healthy range indicator

Large Calculate button

Beautiful input cards

Friendly explanation

──────────────────────────────
ANIMATIONS
──────────────────────────────

Use premium micro interactions.

Fade

Slide

Scale

Hero animation

Ripple

Animated progress

Animated switches

Smooth page transitions

Loading shimmer

Lottie success animation

DO NOT use flashy animations.

Animations should feel smooth and expensive.

──────────────────────────────
ACCESSIBILITY
──────────────────────────────

Design specifically for senior citizens.

Large touch targets

High contrast

Large fonts

Easy navigation

Simple layouts

Minimal cognitive load

Every icon must have a text label.

Avoid clutter.

──────────────────────────────
ICONS
──────────────────────────────

Use Material Symbols Rounded or Cupertino Icons.

Never use emoji as feature icons.

──────────────────────────────
FLUTTER REQUIREMENTS
──────────────────────────────

Material 3

Responsive

Reusable widgets

Dark Mode support

Smooth 60fps animations

Modern Flutter architecture

Production-ready UI

──────────────────────────────
FINAL GOAL
──────────────────────────────

Redesign the existing Senior Reminder App into a premium healthcare application that looks like it was designed by a professional UI/UX agency.

The design should immediately impress users while remaining extremely simple and comfortable for elderly users.

The app should feel worthy of being featured on the App Store or Google Play.