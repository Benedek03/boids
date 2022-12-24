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

<iframe width="100%" height="100%" src="https://www.youtube.com/embed/I0JIVFfPD9w" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

---

# Optimization
1. divide the screen to  squares where the width and height equals the visual range of the boids
0. the boids only need to check the squares where they are and the 8 surrounding it

---

<iframe width="100%" height="100%" src="https://www.youtube.com/embed/AYz-op37B8c" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
