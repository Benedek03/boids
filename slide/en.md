---
marp: true
theme: uncover
class: invert
---

# Boids
Szanka Benedek

---

# How do they work?

---

![bg right height:4in](separation.gif)
# Separation
steer to avoid crowding local flockmates

---

![bg right height:4in](alignment.gif)
# Alignment
steer towards the average heading of local flockmates

---

![bg right height:4in](cohesion.gif)
# Cohesion
steer to move toward the average position of local flockmates

---

<video controls="controls" src="https://user-images.githubusercontent.com/81362206/209197187-509fecf0-9c7d-4eb7-a813-01d25fbf00d5.mp4"></video>

---

# Optimization
1. divide the screen to  squares where the width and height equals 2 * visual range of the boids
0. the boids only need to check the squares where they are and the 8 surrounding it

---

<video controls="controls" src="https://user-images.githubusercontent.com/81362206/209354785-850ac0f3-01e5-41e9-a814-fc3ed5533bad.mp4"></video>
