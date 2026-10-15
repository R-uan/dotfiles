# AMD GPU (iGPU ou Radeon dedicada) — Mesa já fornece RADV (Vulkan) e VA-API
# via hardware.graphics, então aqui só fica o específico do amdgpu.
{...}: {
  # Carrega o amdgpu no initrd (KMS cedo, Plymouth na resolução certa)
  hardware.amdgpu.initrd.enable = true;
}
