# Neovim :: O P T I X

## Speed

`hyperfine 'nvim +q'`

```
Benchmark 1: nvim +q
  Time (mean ± σ):      26.2 ms ±   0.5 ms    [User: 16.6 ms, System: 7.6 ms]
  Range (min … max):    25.2 ms …  27.5 ms    102 runs
```

`hyperfine 'nvim --clean +q'`

```
Benchmark 1: nvim --clean +q
  Time (mean ± σ):      14.2 ms ±   0.5 ms    [User: 9.0 ms, System: 4.8 ms]
  Range (min … max):    13.3 ms …  15.9 ms    173 runs
```

## Acknowledgements

- [bekaboo/nvim](https://github.com/Bekaboo/nvim) (for many plugins and configurations, tree-wide structure, etc)
- [idm1try/dotfiles](https://github.com/idm1try/dotfiles) (for the oxocarbon override layer on [catppuccin/nvim](https://github.com/catppuccin/nvim))
