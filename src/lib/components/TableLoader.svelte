<script lang="ts">
	export let files: any, scalarValueTypes: any;
	import Table from './Table.svelte';
	import Footer from '$lib/components/Footer.svelte';

	const orgMod = files[0];
	let longNames: string[] = [];
	if (orgMod.hasServices || orgMod.hasMessages || orgMod.hasEnums || orgMod.hasExtensions) {
		if (orgMod.hasServices) {
			let tmp = orgMod.services.map((x: { longName: string }) => x.longName);
			longNames = longNames.concat(tmp);
		}
		if (orgMod.hasMessages) {
			let tmp = orgMod.messages.map((x: { longName: string }) => x.longName);
			longNames = longNames.concat(tmp);
		}
		if (orgMod.hasEnums) {
			let tmp = orgMod.enums.map((x: { longName: string }) => x.longName);
			longNames = longNames.concat(tmp);
		}
		if (orgMod.hasExtensions) {
			let tmp = orgMod.extensions.map((x: { longName: string }) => x.longName);
			longNames = longNames.concat(tmp);
		}
	}

	const isImported = (i: number) => {
		let validate = i === 0 ? false : true;
		return validate;
	};

	function closeSidebar(event: MouseEvent & { currentTarget: EventTarget & HTMLDivElement }) {
		if (event.currentTarget.classList.contains('main-content')) {
			if (document.getElementById('open-sidebar')?.classList.contains('hidden')) {
				document.getElementById('sidebar')?.classList.toggle('-translate-x-full');
				document.getElementById('open-sidebar')?.classList.toggle('hidden');
				document.getElementById('close-sidebar')?.classList.toggle('hidden');
			}
		}
	}
</script>

<!-- svelte-ignore missing-declaration -->
<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
	role="button"
	tabindex="0"
	class="pt-[50px] main-content lg:overflow-x-auto cursor-default"
	on:click={closeSidebar}
>
	{#each files as entry, i}
		{#if entry.hasServices || entry.hasMessages || entry.hasEnums || entry.hasExtensions}
			{@const packageName = entry.name.split('/').pop().split('.')[0]}
			{#if files.length > 1}
				<div class="mt-6 px-6 text-center">
					<div class="bg-gray-200 dark:bg-gray-900 py-3">
						<a
							class="text-black dark:text-white hover:underline font-nunito scroll-mt-[90px]"
							id={packageName}
							href="#{packageName}">{packageName}</a
						>
					</div>
				</div>
			{/if}
			{#if entry.hasServices}
				{@const sectionName = 'services'}
				{@const hrefSection = packageName + '.' + sectionName}
				<div class="p-6">
					<div class="my-1">
						<a
							class="text-black dark:text-white hover:underline font-nunito uppercase scroll-mt-[70px]"
							id={hrefSection}
							href="#{hrefSection}">{sectionName}</a
						>
					</div>
					<Table entry={entry.services} {sectionName} imported={isImported(i)} {longNames} />
				</div>
			{/if}
			{#if entry.hasMessages}
				{@const sectionName = 'messages'}
				{@const hrefSection = packageName + '.' + sectionName}
				<div class="p-6">
					<div class="my-1">
						<a
							class="text-black dark:text-white hover:underline font-nunito uppercase scroll-mt-[70px]"
							id={hrefSection}
							href="#{hrefSection}">{sectionName}</a
						>
					</div>
					<Table entry={entry.messages} {sectionName} imported={isImported(i)} {longNames} />
				</div>
			{/if}
			{#if entry.hasEnums}
				{@const sectionName = 'enums'}
				{@const hrefSection = packageName + '.' + sectionName}
				<div class="p-6">
					<div class="my-1">
						<a
							class="text-black dark:text-white hover:underline font-nunito uppercase scroll-mt-[70px]"
							id={hrefSection}
							href="#{hrefSection}">{sectionName}</a
						>
					</div>
					<Table entry={entry.enums} {sectionName} imported={isImported(i)} {longNames} />
				</div>
			{/if}
			{#if entry.hasExtensions}
				{@const sectionName = 'extensions'}
				{@const hrefSection = packageName + '.' + sectionName}
				<div class="p-6">
					<div class="my-1">
						<a
							class="text-black dark:text-white hover:underline font-nunito uppercase scroll-mt-[70px]"
							id={hrefSection}
							href="#{hrefSection}">{sectionName}</a
						>
					</div>
					<Table entry={entry.extensions} {sectionName} imported={isImported(i)} {longNames} />
				</div>
			{/if}
		{/if}
	{/each}
	<div class="p-6">
		<Table entry={scalarValueTypes} sectionName="svt" imported={false} />
	</div>

	<Footer home={false} />
</div>
