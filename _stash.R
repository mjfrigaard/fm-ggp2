d=data.frame(a=c("a","b","c","d","e","f"))
ggplot() +
  geom_point(
    data = d,
    mapping = aes(x = a, y = 0.5, shape = a),
    size = 10
  ) +
  scale_x_discrete(name = "") +
  scale_y_continuous(limits = c(0, 1),
    breaks = NULL,
    name = "") +
  scale_shape_discrete(solid = FALSE) +
  theme(legend.position = "none")
  
d = data.frame(p = c(0:25, 32:127))
ggplot(data = d) +
  geom_point(
    mapping = aes(
      x = p %% 16,
      y = p %/% 16,
      shape = p
    ),
    size = 10,
    fill = "red"
  ) + 
  scale_shape_binned(solid = TRUE) +
  geom_text(mapping = aes(
    x = p %% 16,
    y = p %/% 16 + 0.25,
    label = p
  ),
    size = 5) + 
  scale_shape_identity() +
  scale_y_continuous(name = "") +
  scale_x_continuous(name = "")
  

