# Problemas conhecidos

Problemas de hardware/sistema encontrados nas maquinas e como resolver.

| Host    | Problema                                | Status   |
| ------- | --------------------------------------- | -------- |
| `bunny` | [8 GB de RAM, so 6 GB disponiveis](#bunny-8-gb-de-ram-so-6-gb-disponiveis) | Aberto |

---

## `bunny`: 8 GB de RAM, so 6 GB disponiveis

**Sintoma:** o pente de 8 GB aparece com ~6 GB utilizaveis no sistema.

**Causa provavel:** a iGPU do Ryzen 5 7600 reserva parte da RAM como memoria de video (UMA Frame Buffer). Nas placas AM5 o padrao costuma ser 2 GB. Com a RX 7600 (8 GB de VRAM propria) essa reserva e desperdicio.

**Como confirmar:**

```sh
free -h                                              # total da RAM vista pelo sistema
sudo dmesg | grep -iE 'Memory:|VRAM'                 # RAM e VRAM reservada no boot
cat /sys/class/drm/card*/device/mem_info_vram_total  # VRAM por GPU (bytes); a iGPU com ~2 GB = RAM reservada
```

**Solucao (BIOS MSI, modo Advanced com F7):**

1. `Settings > Advanced > Integrated Graphics Configuration`
2. **Integrated Graphics** = `Disabled` (libera toda a reserva), ou, para manter a iGPU, **UMA Frame Buffer Size** no minimo (`512M`/`64M`)
3. Monitor ligado nas saidas da **RX 7600**, nao no HDMI da placa-mae

Depois disso `free -h` deve mostrar ~7.5 GiB (a diferenca para 8 e normal: GB vs GiB + reserva do firmware).

**Se nao resolver:**

- Conferir na tela da BIOS se ela mesma ve 8192 MB. Se ver menos, reencaixar o pente
- Com um pente so, usar o slot **A2** (segundo a partir da CPU), recomendado pela MSI
