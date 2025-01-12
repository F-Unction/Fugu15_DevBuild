#import <spawn.h>
#import "../systemhook/src/common.h"
#import "substrate.h"

int posix_spawnattr_setjetsam(posix_spawnattr_t *attr, short flags, int priority, int memlimit);
int posix_spawnattr_setjetsam_ext(posix_spawnattr_t *attr, short flags, int priority, int memlimit_active, int memlimit_inactive);

void *posix_spawn_orig;
void *posix_spawnattr_setjetsam_orig;
void *posix_spawnattr_setjetsam_ext_orig;

int posix_spawn_hook(pid_t *restrict pid, const char *restrict path,
					   const posix_spawn_file_actions_t *restrict file_actions,
					   const posix_spawnattr_t *restrict attrp,
					   char *const argv[restrict],
					   char *const envp[restrict])
{
	return spawn_hook_common(pid, path, file_actions, attrp, argv, envp, posix_spawn_orig);
}

int posix_spawnattr_setjetsam_hook(posix_spawnattr_t *attr, short flags, int priority, int memlimit)
{
	//return posix_spawnattr_setjetsam_replacement(attr, flags, priority, memlimit, posix_spawnattr_setjetsam_orig);
	int (*orig)(posix_spawnattr_t *, short, int, int) = posix_spawnattr_setjetsam_orig;
	return orig(attr, flags, priority, memlimit);
}

int posix_spawnattr_setjetsam_ext_hook(posix_spawnattr_t *attr, short flags, int priority, int memlimit_active, int memlimit_inactive)
{
	//return posix_spawnattr_setjetsam_ext_replacement(attr, flags, priority, memlimit_active, memlimit_inactive, posix_spawnattr_setjetsam_ext_orig);
	int (*orig)(posix_spawnattr_t *, short, int, int, int) = posix_spawnattr_setjetsam_ext_orig;
	return orig(attr, flags, priority, memlimit_active, memlimit_inactive);
}

void initSpawnHooks(void)
{
	MSHookFunction(&posix_spawn, (void *)posix_spawn_hook, &posix_spawn_orig);
	//MSHookFunction(&posix_spawnattr_setjetsam, (void *)posix_spawnattr_setjetsam_hook, &posix_spawnattr_setjetsam_orig);
	//MSHookFunction(&posix_spawnattr_setjetsam_ext, (void *)posix_spawnattr_setjetsam_ext_hook, &posix_spawnattr_setjetsam_ext_orig);
}