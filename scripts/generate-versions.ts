import { getAllVersions } from "@biomejs/version-utils";
import { coerce, gt, gte, type SemVer } from "semver";

const yankedVersions: string[] = ["2.0.1", "2.0.2", "2.0.3"];

const semverVersions = ((await getAllVersions(true)) ?? [])
	?.map((v) => coerce(v, { includePrerelease: true }))
	.filter((v) => v !== null)
	.filter((v) => gte(v, "1.7.0"))
	.filter(
		(v) => !v.prerelease.some((pre) => pre.toString().includes("nightly")),
	)
	.filter((v) => !yankedVersions.includes(v.format()));

const getGreatestMinorForMajor = (versions: SemVer[]): Map<string, string> => {
	const greatestMinorVersionForMajor: Map<string, string> = new Map<
		string,
		string
	>([]);

	for (const version of versions ?? []) {
		const semver = version;

		if (!semver?.major) {
			continue;
		}

		if (!greatestMinorVersionForMajor.has(`${semver.major}`)) {
			greatestMinorVersionForMajor.set(`${semver.major}`, version.format());
		} else {
			const newMax = coerce(
				greatestMinorVersionForMajor.get(`${semver.major}`),
			);

			if (!newMax) {
				continue;
			}

			if (gt(semver, newMax)) {
				greatestMinorVersionForMajor.set(`${semver.major}`, version.format());
			}
		}
	}

	return greatestMinorVersionForMajor;
};

const getGreatestPatchForMajorMinor = (
	versions: SemVer[],
): Map<string, string> => {
	const greatestPatchVersionForMajor: Map<string, string> = new Map<
		string,
		string
	>([]);

	for (const version of versions ?? []) {
		const semver = version;

		if (!semver?.major || !semver?.minor) {
			continue;
		}

		if (!greatestPatchVersionForMajor.has(`${semver.major}.${semver.minor}`)) {
			greatestPatchVersionForMajor.set(
				`${semver.major}.${semver.minor}`,
				version.format(),
			);
		} else {
			const newMax = coerce(
				greatestPatchVersionForMajor.get(`${semver.major}.${semver.minor}`),
			);

			if (!newMax) {
				continue;
			}

			if (gt(semver, newMax)) {
				greatestPatchVersionForMajor.set(
					`${semver.major}.${semver.minor}`,
					version.format(),
				);
			}
		}
	}

	return greatestPatchVersionForMajor;
};

const greatestMinorForMajor = getGreatestMinorForMajor(semverVersions);
const greatestPatchForMajorMinor =
	getGreatestPatchForMajorMinor(semverVersions);

/**
 * Generate a list of all verions of Biome for which we want to create
 * Docker images.
 *
 * For beta versions, we only create images for the patch versions.
 */
export const versions = semverVersions.map((version: SemVer) => {
	return {
		major: `${version.major}`,
		minor: `${version.major}.${version.minor}`,
		patch: version.format(),
		createMajor:
			greatestMinorForMajor.get(`${version.major}`) === version.format() &&
			!version.prerelease.includes("beta"),
		createMinor:
			greatestPatchForMajorMinor.get(`${version.major}.${version.minor}`) ===
				version.format() && !version.prerelease.includes("beta"),
	};
});

console.log(JSON.stringify(versions));
