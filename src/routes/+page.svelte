<script lang="ts">
	import '../app.css';

	import yaml from 'js-yaml';

	import Footer from '$lib/components/Footer.svelte';

	import type { Services } from '$lib/interfaces';
	import ifcLoad from '$lib/ndk.yaml?raw';

	const services = yaml.load(ifcLoad) as Services;
	// key is the top level element in the ndk.yaml that groups all the services
	const key = 'services';

	// pathKey is the key to append to the path to get to the doc
	// page of a particular service
	const pathKey = 'doc';

	let panelList: any[] = [];
	Object.keys(services[key]).forEach((el) => {
		panelList.push({
			name: services[key][el].name,
			desc: services[key][el].description,
			href: `${pathKey}/${el}`
		});
	});
</script>

<svelte:head>
	<title>SR Linux NDK Service Documentation</title>
</svelte:head>

<div class="flex flex-col items-center min-h-screen pt-5 has-header-img font-nunito">
	<div class="flex-grow-1 flex-shrink-0 m-auto px-10">
		<div class="md:grid md:grid-cols-2 md:gap-20 md:items-center">
			<div>
				<p class="mb-4"><img src="/images/nokia_w.svg" width="100" alt="Logo" /></p>
				<h3 class="text-3xl text-yellow-200 font-light mt-6">SR Linux NDK Service Documentation</h3>
				<div class="text-white mt-4 max-w-[450px] text-m">
					<p>
						SR Linux empowers users to enhance the system's capabilities by incorporating custom
						applications that run seamlessly alongside native system applications.
					</p>
					<p class="mt-4">
						<a
							class="underline text-blue-500 hover:text-blue-400"
							href="https://learn.srlinux.dev/ndk/">SR Linux NDK (NetOps Development Kit)</a
						> underpins this extensibility by providing a set of APIs and tools for developers to customize
						the Network OS to their unique needs and requirements.
					</p>
				</div>
			</div>
			<div class="mt-5 bg-white rounded-lg shadow-xl">
				<div class="my-1.5 h-[305px] overflow-y-auto scroll-light">
					<ul>
						{#each panelList as item, i}
							<li
								class="items-center p-4 text-gray-900 hover:bg-gray-100 {i > 0 ? 'border-t' : ''}"
							>
								<a data-sveltekit-reload href={item.href}>
									<p class="">{item.name}</p>
									{#if item.desc}
										<p class="mt-1 font-light text-sm">{item.desc}</p>
									{/if}
								</a>
							</li>
						{/each}
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div class="flex-grow-0 flex-shrink-0">
		<Footer home={true} />
	</div>
</div>
